import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/constants/app_constants.dart';
import '../base/constants/app_size.dart';

/// Button Widget - Theme Aware & Minimalist
class ButtonWidget extends StatelessWidget {
  final String textTitle;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;
  final Widget? icon;
  final bool isLoading;
  final bool isOutlined;

  const ButtonWidget({
    Key? key,
    required this.textTitle,
    this.onTap,
    this.enabled = true,
    this.color,
    this.textColor,
    this.height,
    this.width,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.primaryColor;
    final buttonTextColor = textColor ?? theme.colorScheme.onPrimary;
    final isButtonEnabled = enabled && !isLoading;

    return SizedBox(
      height: height ?? 56.h, // Taller, more clickable
      width: width,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isButtonEnabled ? onTap : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isButtonEnabled ? buttonColor : AppColors.grey,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                foregroundColor: buttonColor,
              ),
              child: _buildButtonContent(buttonColor),
            )
          : ElevatedButton(
              onPressed: isButtonEnabled ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled ? buttonColor : AppColors.greyLight,
                foregroundColor: buttonTextColor,
                elevation: 0, // Flat design
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                shadowColor: Colors.transparent,
              ),
              child: _buildButtonContent(buttonTextColor),
            ),
    );
  }

  Widget _buildButtonContent(Color contentColor) {
    if (isLoading) {
      return SizedBox(
        height: 24.h,
        width: 24.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(contentColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(color: contentColor, size: 20.sp),
            child: icon!,
          ),
          SizedBox(width: 8.w),
          Text(
            textTitle,
            style: TextStyle(
              color: contentColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    }

    return Text(
      textTitle,
      style: TextStyle(
        color: contentColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
