import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/constants/app_constants.dart';
import '../base/constants/app_size.dart';
import '../common_widgets/button_widget.dart';

/// Error State Widget - Gelişmiş hata durumu widget'ı
class ErrorStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? retryText;
  final VoidCallback? onRetry;
  final double iconSize;

  const ErrorStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.retryText,
    this.onRetry,
    this.iconSize = 64.0,
  }) : super(key: key);

  /// Network Error State
  factory ErrorStateWidget.networkError({
    String? retryText,
    VoidCallback? onRetry,
  }) {
    return ErrorStateWidget(
      icon: Icons.wifi_off,
      title: 'Bağlantı Hatası',
      message: 'İnternet bağlantınızı kontrol edin ve tekrar deneyin.',
      retryText: retryText ?? 'Tekrar Dene',
      onRetry: onRetry,
    );
  }

  /// Server Error State
  factory ErrorStateWidget.serverError({
    String? retryText,
    VoidCallback? onRetry,
  }) {
    return ErrorStateWidget(
      icon: Icons.error_outline,
      title: 'Sunucu Hatası',
      message: 'Bir şeyler ters gitti. Lütfen daha sonra tekrar deneyin.',
      retryText: retryText ?? 'Tekrar Dene',
      onRetry: onRetry,
    );
  }

  /// Generic Error State
  factory ErrorStateWidget.generic({
    required String title,
    required String message,
    String? retryText,
    VoidCallback? onRetry,
  }) {
    return ErrorStateWidget(
      icon: Icons.error_outline,
      title: title,
      message: message,
      retryText: retryText ?? 'Tekrar Dene',
      onRetry: onRetry,
    );
  }

  /// Form Validation Error
  factory ErrorStateWidget.validationError({
    required String message,
  }) {
    return ErrorStateWidget(
      icon: Icons.info_outline,
      title: 'Doğrulama Hatası',
      message: message,
      retryText: null,
      onRetry: null,
      iconSize: 48.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.sizeXLarge.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(AppSizes.sizeLarge.w),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize.sp,
                color: AppColors.errorColor,
              ),
            ),
            
            SizedBox(height: AppSizes.sizeXLarge.h),
            
            // Title
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: AppSizes.sizeMedium.h),
            
            // Message
            Text(
              message,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Retry Button
            if (retryText != null && onRetry != null) ...[
              SizedBox(height: AppSizes.sizeXLarge.h),
              SizedBox(
                width: double.infinity,
                child: ButtonWidget(
                  textTitle: retryText!,
                  color: AppColors.primary,
                  onTap: onRetry!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

