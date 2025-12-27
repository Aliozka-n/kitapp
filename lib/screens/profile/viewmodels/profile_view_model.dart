import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../base/services/favorites_service.dart';
import '../../../domain/dtos/book_dto.dart';
import '../../../domain/dtos/user_dto.dart';
import '../../../utils/shared_preferences_util.dart';
import '../../../utils/navigation_util.dart';
import '../../../utils/book_event_bus.dart';
import '../profile_service.dart';

/// Profile ViewModel - Profile ekranının durum ve iş kuralları
class ProfileViewModel extends BaseViewModel {
  final ProfileService service;

  // PRIVATE FIELDS
  UserResponse? _user;
  String? _errorMessage;
  int _sharedBooksCount = 0;
  List<BookResponse> _myBooks = [];
  List<BookResponse> _favoriteBooks = [];
  int _selectedTabIndex = 0; // 0: My Books, 1: Favorites
  final FavoritesService _favoritesService = FavoritesService();
  StreamSubscription<BookEvent>? _bookEventSubscription;

  // PUBLIC GETTERS
  UserResponse? get user => _user;
  String? get errorMessage => _errorMessage;
  int get sharedBooksCount => _sharedBooksCount;
  List<BookResponse> get myBooks => _myBooks;
  List<BookResponse> get favoriteBooks => _favoriteBooks;
  int get selectedTabIndex => _selectedTabIndex;

  // Constructor
  ProfileViewModel({required this.service}) {
    _listenToBookEvents();
  }

  /// Kitap değişikliklerini dinle
  void _listenToBookEvents() {
    _bookEventSubscription = BookEventBus().events.listen((event) {
      // Profil verilerini yenile
      refresh();
    });
  }

  @override
  FutureOr<void> init() async {
    await loadProfile();
    await loadSharedBooksCount();
    await loadMyBooks();
    await loadFavoriteBooks();
  }

  /// Profil yükle
  Future<void> loadProfile() async {
    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.getProfile();

      if (response.isSuccessful && response.data != null) {
        _user = response.data!;
        _errorMessage = null;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Profil yüklenemedi';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Profil yüklenirken hata oluştu';
      reloadState();
    } finally {
      isLoading = false;
    }
  }

  /// Paylaşılan kitap sayısını yükle
  Future<void> loadSharedBooksCount() async {
    try {
      final response = await service.getSharedBooksCount();
      if (response.isSuccessful && response.data != null) {
        _sharedBooksCount = response.data!;
        reloadState();
      }
    } catch (e) {
      // Hata durumunda sessizce geç
    }
  }

  /// Kendi kitaplarını yükle
  Future<void> loadMyBooks() async {
    try {
      final response = await service.getCurrentlySharedBooks();
      if (response.isSuccessful && response.data != null) {
        _myBooks = (response.data as List)
            .map((item) => BookResponse.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList();
        reloadState();
      }
    } catch (e) {
      // Hata durumunda sessizce geç
    }
  }

  /// Favori kitapları yükle
  Future<void> loadFavoriteBooks() async {
    try {
      final response = await _favoritesService.getFavorites();
      if (response.isSuccessful && response.data != null) {
        _favoriteBooks = response.data!;
        reloadState();
      }
    } catch (e) {
      // Hata durumunda sessizce geç
    }
  }

  /// Tab değiştir
  void setTabIndex(int index) {
    _selectedTabIndex = index;
    reloadState();
  }

  /// Tüm verileri yeniden yükle (Pull to Refresh için)
  Future<void> refresh() async {
    await Future.wait([
      loadProfile(),
      loadSharedBooksCount(),
      loadMyBooks(),
      loadFavoriteBooks(),
    ]);
  }

  /// Logout işlemi (Alias for view consistency)
  Future<void> signOut(BuildContext context) async {
    final success = await logout(context);
    if (success && context.mounted) {
      NavigationUtil.navigateToLogin(context);
    }
  }

  /// Logout işlemi
  Future<bool> logout(BuildContext context) async {
    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.logout();

      if (response.isSuccessful) {
        // SharedPreferences'ı temizle
        final prefs = await SharedPreferencesUtil.getInstance();
        await prefs.removeToken();
        await prefs.remove('userId');
        await prefs.remove('rememberedEmail');
        await prefs.setBool('rememberMe', false);
        
        isLoading = false;
        return true;
      } else {
        _errorMessage = response.message ?? 'Çıkış yapılamadı';
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Çıkış yapılırken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }

  /// Kendi kitabını sil
  Future<void> deleteBook(BuildContext context, String bookId) async {
    isLoading = true;
    try {
      final response = await service.deleteBook(bookId);

      if (response.isSuccessful) {
        // Event fırlat
        BookEventBus().fire(BookEvent(bookId: bookId, type: BookEventType.deleted));
        // Profil verilerini yenile
        await refresh();
        // Başarı dialog'u göster
        if (context.mounted) {
          _showSuccessDialog(
            context,
            title: 'KİTAP SİLİNDİ',
            message: 'Kitap başarıyla kütüphanenden kaldırıldı.',
            icon: Icons.delete_sweep_rounded,
          );
        }
      } else {
        _handleError(context, response.message ?? 'Kitap silinemedi');
      }
    } catch (e) {
      _handleError(context, 'Kitap silinirken bir hata oluştu');
    } finally {
      isLoading = false;
    }
  }

  /// Favoriden çıkar
  Future<void> removeFavorite(BuildContext context, String bookId) async {
    isLoading = true;
    try {
      final response = await _favoritesService.removeFavorite(bookId);

      if (response.isSuccessful) {
        // Event fırlat
        BookEventBus().fire(BookEvent(bookId: bookId, type: BookEventType.favoriteRemoved));
        // Profil verilerini yenile
        await refresh();
        // Başarı dialog'u göster
        if (context.mounted) {
          _showSuccessDialog(
            context,
            title: 'FAVORİDEN ÇIKARILDI',
            message: 'Kitap favorilerinden kaldırıldı.',
            icon: Icons.heart_broken_rounded,
          );
        }
      } else {
        _handleError(context, response.message ?? 'Favoriden çıkarılamadı');
      }
    } catch (e) {
      _handleError(context, 'Favoriden çıkarılırken bir hata oluştu');
    } finally {
      isLoading = false;
    }
  }

  /// Başarılı işlem sonrası dialog - Ana sayfaya yönlendirme ile
  void _showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (dialogContext) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        builder: (context, value, child) => Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: AlertDialog(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.r),
                side: BorderSide(color: AppColors.successColor.withOpacity(0.3), width: 1.5),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(28.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primaryLight.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success Icon with Glow
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.successColor.withOpacity(0.2),
                            AppColors.successColor.withOpacity(0.05),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.successColor.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.successColor,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
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
                    SizedBox(height: 8.h),
                    // Info Text
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.accentCyan.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.accentCyan,
                            size: 18.sp,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              'Değişikliklerin görünmesi için ana sayfayı yenileyebilirsin.',
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
                    // Actions
                    Row(
                      children: [
                        // Kapat butonu
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(dialogContext),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Center(
                                child: Text(
                                  'KAPAT',
                                  style: GoogleFonts.outfit(
                                    color: AppColors.textSecondary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Ana Sayfayı Yenile butonu
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(dialogContext);
                              NavigationUtil.navigateToHome(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.successColor,
                                    AppColors.successColor.withOpacity(0.8),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.successColor.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'YENİLE',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  /// Hata yönetimi ve yönlendirme
  void _handleError(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.errorColor, size: 28.sp),
            SizedBox(width: 12.w),
            Text(
              'İŞLEM BAŞARISIZ',
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textSecondary,
            fontSize: 15.sp,
            height: 1.5,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.h, right: 12.w),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.accent.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
              onPressed: () {
                Navigator.pop(context); // Dialog'u kapat
                NavigationUtil.navigateToHome(context); // Ana sayfaya yönlendir
              },
              child: Text(
                'TAMAM',
                style: GoogleFonts.outfit(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bookEventSubscription?.cancel();
    super.dispose();
  }
}

