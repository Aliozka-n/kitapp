import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/constants/app_constants.dart';
import '../base/constants/app_size.dart';
import '../common_widgets/button_widget.dart';

/// Empty State Widget - Gelişmiş boş durum widget'ı
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final double iconSize;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.iconSize = 64.0,
  }) : super(key: key);

  /// No Books Empty State
  factory EmptyStateWidget.noBooks({
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyStateWidget(
      icon: Icons.book_outlined,
      title: 'Henüz kitap yok',
      message: 'İlk kitabınızı ekleyerek başlayın!',
      actionText: actionText ?? 'Kitap Ekle',
      onAction: onAction,
    );
  }

  /// No Messages Empty State
  factory EmptyStateWidget.noMessages({
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyStateWidget(
      icon: Icons.message_outlined,
      title: 'Henüz mesaj yok',
      message: 'Henüz hiç mesajınız bulunmuyor.',
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// No Search Results Empty State
  factory EmptyStateWidget.noSearchResults({
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'Sonuç bulunamadı',
      message: 'Arama kriterlerinize uygun sonuç bulunamadı.',
      actionText: actionText ?? 'Aramayı Temizle',
      onAction: onAction,
    );
  }

  /// No Favorites Empty State
  factory EmptyStateWidget.noFavorites({
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'Favori kitap yok',
      message: 'Henüz favori listenize kitap eklemediniz.',
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// Generic Empty State
  factory EmptyStateWidget.generic({
    required IconData icon,
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyStateWidget(
      icon: icon,
      title: title,
      message: message,
      actionText: actionText,
      onAction: onAction,
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
                color: AppColors.greyLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize.sp,
                color: AppColors.textLight,
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

            // Action Button
            if (actionText != null && onAction != null) ...[
              SizedBox(height: AppSizes.sizeXLarge.h),
              SizedBox(
                width: double.infinity,
                child: ButtonWidget(
                  textTitle: actionText!,
                  color: AppColors.primary,
                  onTap: onAction!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
