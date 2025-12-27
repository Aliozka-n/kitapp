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
  final IconData? icon;

  const ButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.isSecondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
        (isSecondary ? AppColors.primaryLight : AppColors.accent);
    
    final effectiveTextColor = textColor ?? AppColors.textWhite;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 60.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: isSecondary ? null : AppGradients.cosmic,
            color: isSecondary ? effectiveBackgroundColor : null,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: isSecondary ? [] : AppShadows.glow,
            border: Border.all(
              color: isSecondary 
                  ? Colors.white.withOpacity(0.1) 
                  : Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              children: [
                // Subtle shimmer/glow effect
                if (!isSecondary)
                  Positioned(
                    top: -20,
                    left: -20,
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 40.r,
                          )
                        ],
                      ),
                    ),
                  ),
                
                Center(
                  child: isLoading
                      ? SizedBox(
                          height: 24.h,
                          width: 24.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (icon != null) ...[
                              Icon(icon, color: effectiveTextColor, size: 20.sp),
                              SizedBox(width: 10.w),
                            ],
                            Text(
                              text,
                              style: GoogleFonts.outfit(
                                color: effectiveTextColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


