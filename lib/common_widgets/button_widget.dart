import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../base/constants/app_constants.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isSecondary;

  const ButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isSecondary 
        ? AppColors.backgroundLight 
        : (backgroundColor ?? AppColors.primary);
    
    final effectiveTextColor = isSecondary 
        ? AppColors.primary 
        : (textColor ?? AppColors.textWhite);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: IntrinsicHeight(
          child: Stack(
            children: [
              // Brutalist shadow offset
              if (onPressed != null && !isLoading)
                Positioned(
                  top: 4.h,
                  left: 4.w,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
              // Main button body
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                margin: EdgeInsets.only(
                  bottom: (onPressed != null && !isLoading) ? 4.h : 0,
                  right: (onPressed != null && !isLoading) ? 4.w : 0,
                ),
                height: 56.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: effectiveBackgroundColor,
                  border: Border.all(
                    color: AppColors.primary, 
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: isLoading
                    ? SizedBox(
                        height: 24.h,
                        width: 24.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                        ),
                      )
                    : Text(
                        text.toUpperCase(),
                        style: GoogleFonts.syne(
                          color: effectiveTextColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

