import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/constants/app_constants.dart';
import '../base/constants/app_size.dart';
import '../base/constants/app_texts.dart';
import 'button_widget.dart';

/// Alert Dialog Widget - Reusable dialog widget
class AlertDialogWidget {
  /// Show success dialog
  static Future<void> showSuccessfulDialog(
    BuildContext context,
    String message, {
    VoidCallback? onOk,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.successColor,
              size: 28.sp,
            ),
            SizedBox(width: AppSizes.sizeSmall.w),
            Text(
              'Başarılı',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16.sp,
          ),
        ),
        actions: [
          ButtonWidget(
            textTitle: AppTexts.ok,
            onTap: () {
              Navigator.pop(context);
              onOk?.call();
            },
            width: 100.w,
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  static Future<void> showErrorDialog(
    BuildContext context,
    String message, {
    VoidCallback? onOk,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error,
              color: AppColors.errorColor,
              size: 28.sp,
            ),
            SizedBox(width: AppSizes.sizeSmall.w),
            Text(
              'Hata',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16.sp,
          ),
        ),
        actions: [
          ButtonWidget(
            textTitle: AppTexts.ok,
            onTap: () {
              Navigator.pop(context);
              onOk?.call();
            },
            width: 100.w,
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String message, {
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
        ),
        title: Text(
          'Onay',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText ?? AppTexts.cancel,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16.sp,
              ),
            ),
          ),
          ButtonWidget(
            textTitle: confirmText ?? AppTexts.ok,
            onTap: () {
              Navigator.pop(context, true);
              onConfirm?.call();
            },
            width: 100.w,
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Show input dialog
  static Future<String?> showInputDialog(
    BuildContext context,
    String title, {
    String? hintText,
    String? initialValue,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? textField,
  }) {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Form(
          key: formKey,
          child: textField ??
              TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                validator: validator,
                decoration: InputDecoration(
                  hintText: hintText,
                ),
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppTexts.cancel,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16.sp,
              ),
            ),
          ),
          ButtonWidget(
            textTitle: AppTexts.ok,
            onTap: () {
              if (formKey.currentState?.validate() ?? true) {
                Navigator.pop(context, controller.text);
              }
            },
            width: 100.w,
          ),
        ],
      ),
    );
  }
}

