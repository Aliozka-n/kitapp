import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../utils/navigation_util.dart';
import '../settings_service.dart';

/// Settings ViewModel - Ayarlar ekranının state yönetimi
class SettingsViewModel extends BaseViewModel {
  final SettingsService service;

  // PRIVATE FIELDS
  bool _pushNotificationsEnabled = true;
  bool _chatNotificationsEnabled = true;
  bool _locationVisible = true;
  String _appVersion = '1.0.0';
  String? _errorMessage;

  // CONTROLLERS
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // PUBLIC GETTERS
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get chatNotificationsEnabled => _chatNotificationsEnabled;
  bool get locationVisible => _locationVisible;
  String get appVersion => _appVersion;
  String? get errorMessage => _errorMessage;

  // Constructor
  SettingsViewModel({required this.service});

  @override
  FutureOr<void> init() async {
    await _loadSettings();
  }

  /// Ayarları yükle
  Future<void> _loadSettings() async {
    _pushNotificationsEnabled = await service.getNotificationSetting('push_notifications');
    _chatNotificationsEnabled = await service.getNotificationSetting('chat_notifications');
    _locationVisible = await service.getNotificationSetting('location_visible');
    _appVersion = service.getAppVersion();
    reloadState();
  }

  /// Push bildirimleri toggle
  Future<void> togglePushNotifications(bool value) async {
    _pushNotificationsEnabled = value;
    reloadState();
    await service.updateNotificationSetting(key: 'push_notifications', value: value);
  }

  /// Chat bildirimleri toggle
  Future<void> toggleChatNotifications(bool value) async {
    _chatNotificationsEnabled = value;
    reloadState();
    await service.updateNotificationSetting(key: 'chat_notifications', value: value);
  }

  /// Konum görünürlüğü toggle
  Future<void> toggleLocationVisibility(bool value) async {
    _locationVisible = value;
    reloadState();
    await service.updateNotificationSetting(key: 'location_visible', value: value);
  }

  /// Şifre değiştir
  Future<bool> changePassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) return false;

    if (newPasswordController.text != confirmPasswordController.text) {
      _showErrorSnackBar(context, 'Şifreler eşleşmiyor');
      return false;
    }

    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (response.isSuccessful) {
        _clearPasswordFields();
        isLoading = false;
        return true;
      } else {
        _errorMessage = response.message;
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Şifre değiştirilirken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }

  /// Hesabı sil (eski - dialog ile)
  Future<void> deleteAccount(BuildContext context) async {
    isLoading = true;

    try {
      final response = await service.deleteAccount();

      if (response.isSuccessful && context.mounted) {
        isLoading = false;
        NavigationUtil.navigateToLogin(context);
      } else {
        _errorMessage = response.message;
        isLoading = false;
        reloadState();
        if (context.mounted) {
          _showErrorSnackBar(context, response.message ?? 'Hesap silinemedi');
        }
      }
    } catch (e) {
      _errorMessage = 'Hesap silinirken hata oluştu';
      isLoading = false;
      reloadState();
    }
  }

  /// Hesabı şifre ile sil (yeni - double password verification)
  Future<bool> deleteAccountWithPassword(BuildContext context, String password) async {
    _errorMessage = null;

    try {
      // Önce şifreyi doğrula
      final verifyResponse = await service.verifyPassword(password);

      if (!verifyResponse.isSuccessful) {
        _errorMessage = 'Şifre yanlış';
        reloadState();
        return false;
      }

      // Şifre doğruysa hesabı sil
      final deleteResponse = await service.deleteAccount();

      if (deleteResponse.isSuccessful && context.mounted) {
        Navigator.pop(context); // Bottom sheet'i kapat
        NavigationUtil.navigateToLogin(context);
        return true;
      } else {
        _errorMessage = deleteResponse.message ?? 'Hesap silinemedi';
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Hesap silinirken hata oluştu';
      reloadState();
      return false;
    }
  }

  /// Cache temizle
  Future<void> clearCache(BuildContext context) async {
    isLoading = true;

    try {
      final response = await service.clearCache();

      isLoading = false;
      if (context.mounted) {
        if (response.isSuccessful) {
          _showSuccessSnackBar(context, 'Önbellek temizlendi');
        } else {
          _showErrorSnackBar(context, response.message ?? 'Hata oluştu');
        }
      }
    } catch (e) {
      isLoading = false;
      if (context.mounted) {
        _showErrorSnackBar(context, 'Önbellek temizlenirken hata oluştu');
      }
    }
  }

  /// Şifre alanlarını temizle
  void _clearPasswordFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  /// Error snackbar göster
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  /// Success snackbar göster
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  /// Hesap silme onay dialog'unu göster
  void showDeleteAccountDialog(BuildContext context) {
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
                side: BorderSide(color: AppColors.errorColor.withOpacity(0.3), width: 1.5),
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
                    // Warning Icon
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.errorColor.withOpacity(0.2),
                            AppColors.errorColor.withOpacity(0.05),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.errorColor.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.errorColor,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    // Title
                    Text(
                      'HESABI SİL',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: AppColors.errorColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Message
                    Text(
                      'Bu işlem geri alınamaz!\n\nTüm kitapların, favorilerin ve mesajların kalıcı olarak silinecek.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Actions
                    Row(
                      children: [
                        // İptal butonu
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
                                  'İPTAL',
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
                        // Sil butonu
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(dialogContext);
                              deleteAccount(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.errorColor,
                                    AppColors.errorColor.withOpacity(0.8),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.errorColor.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'SİL',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
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

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
