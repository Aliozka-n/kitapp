import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/models/service_response.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/book_dto.dart';
import '../../../utils/book_event_bus.dart';
import '../../../utils/navigation_util.dart';
import '../book_detail_service.dart';

/// Book Detail ViewModel - Book Detail ekranının durum ve iş kuralları
class BookDetailViewModel extends BaseViewModel {
  final BookDetailService service;
  final String bookId;

  // PRIVATE FIELDS
  BookResponse? _book;
  String? _errorMessage;
  bool _isFavorite = false;

  // PUBLIC GETTERS
  BookResponse? get book => _book;
  String? get errorMessage => _errorMessage;
  bool get isFavorite => _isFavorite;

  // Owner bilgileri
  String? get ownerId => _book?.userId;
  String? get ownerName => _book?.userName ?? 'Kullanıcı';

  // Kullanıcı kendi kitabına mı bakıyor?
  bool get isMyBook {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    return currentUserId != null && ownerId == currentUserId;
  }

  // Constructor
  BookDetailViewModel({
    required this.service,
    required this.bookId,
  });

  @override
  FutureOr<void> init() async {
    await loadBookDetail();
    await checkFavoriteStatus();
  }

  /// Book detail yükle
  Future<void> loadBookDetail() async {
    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.getBookDetail(bookId);

      if (response.isSuccessful && response.data != null) {
        _book = response.data!;
        _errorMessage = null;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Kitap detayı yüklenemedi';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Kitap detayı yüklenirken hata oluştu';
      reloadState();
    } finally {
      isLoading = false;
    }
  }

  /// Favori durumunu kontrol et
  Future<void> checkFavoriteStatus() async {
    try {
      final response = await service.isFavorite(bookId);
      if (response.isSuccessful) {
        _isFavorite = response.data ?? false;
        reloadState();
      }
    } catch (e) {
      // Sessizce geç
    }
  }

  /// Favori ekle/çıkar
  Future<bool> toggleFavorite() async {
    try {
      ServiceResponse<bool> response;

      if (_isFavorite) {
        response = await service.removeFavorite(bookId);
      } else {
        response = await service.addFavorite(bookId);
      }

      if (response.isSuccessful) {
        _isFavorite = !_isFavorite;
        reloadState();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Kitap sil - BookEventBus ile tüm ekranları senkronize eder
  Future<bool> deleteBook(BuildContext context) async {
    isLoading = true;
    _errorMessage = null;
    reloadState();

    try {
      final response = await service.deleteBook(bookId);

      if (response.isSuccessful) {
        isLoading = false;

        // Event fırlat - Tüm ekranlar bu olayı dinleyecek
        BookEventBus()
            .fire(BookEvent(bookId: bookId, type: BookEventType.deleted));

        // Başarı dialog'u göster
        if (context.mounted) {
          _showSuccessDialog(
            context,
            title: 'KİTAP SİLİNDİ',
            message: 'Kitap başarıyla kütüphanenden kaldırıldı.',
            icon: Icons.delete_sweep_rounded,
          );
        }
        return true;
      } else {
        _errorMessage = response.message ?? 'Kitap silinemedi';
        isLoading = false;
        if (context.mounted) {
          _handleError(context, _errorMessage!);
        }
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Kitap silinirken hata oluştu';
      isLoading = false;
      if (context.mounted) {
        _handleError(context, _errorMessage!);
      }
      reloadState();
      return false;
    }
  }

  /// Favori toggle - BookEventBus ile tüm ekranları senkronize eder
  Future<bool> toggleFavoriteWithContext(BuildContext context) async {
    try {
      ServiceResponse<bool> response;

      if (_isFavorite) {
        response = await service.removeFavorite(bookId);
      } else {
        response = await service.addFavorite(bookId);
      }

      if (response.isSuccessful) {
        final wasAdded = !_isFavorite;
        _isFavorite = !_isFavorite;

        // Event fırlat
        BookEventBus().fire(BookEvent(
          bookId: bookId,
          type: wasAdded
              ? BookEventType.favoriteAdded
              : BookEventType.favoriteRemoved,
        ));

        reloadState();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Başarılı işlem sonrası dialog - Futuristik tasarım
  void _showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (dialogContext) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        builder: (context, value, child) => Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primaryLight.withOpacity(0.95),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.successColor.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.successColor.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Icon Container
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) => Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.successColor,
                                AppColors.successColor.withOpacity(0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.successColor.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 40.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Message
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textSecondary,
                        fontSize: 15.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Info Banner
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                            color: AppColors.accentCyan.withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.accentCyan,
                            size: 18.sp,
                          ),
                          SizedBox(width: 10.w),
                          Flexible(
                            child: Text(
                              'Değişiklikler ana sayfaya yansıyacak.',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.accentCyan,
                                fontSize: 12.sp,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),
                    // Action Button - Gradient
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
                        NavigationUtil.navigateToHome(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.successColor,
                              AppColors.successColor.withOpacity(0.75),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.successColor.withOpacity(0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'ANA SAYFAYA DÖN',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Hata yönetimi - Futuristik tasarım
  void _handleError(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (dialogContext) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        builder: (context, value, child) => Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primaryLight.withOpacity(0.95),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.errorColor.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.errorColor.withOpacity(0.15),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Error Icon
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.errorColor,
                            AppColors.errorColor.withOpacity(0.7),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.errorColor.withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: Colors.white,
                        size: 36.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Title
                    Text(
                      'İŞLEM BAŞARISIZ',
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Message
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    // Action Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
                        NavigationUtil.navigateToHome(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColors.errorColor.withOpacity(0.15),
                          border: Border.all(
                            color: AppColors.errorColor.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'TAMAM',
                            style: GoogleFonts.outfit(
                              color: AppColors.errorColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
