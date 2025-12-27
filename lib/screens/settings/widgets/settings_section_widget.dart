import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';

/// Settings Section Widget - Glassmorphism Section Container
class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: AppColors.primaryLight,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor.withOpacity(0.15),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            Divider(
              color: Colors.white.withOpacity(0.05),
              height: 1,
            ),
            // Children with dividers
            ...List.generate(children.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Divider(
                  color: Colors.white.withOpacity(0.03),
                  height: 1,
                  indent: 72.w,
                );
              }
              return children[index ~/ 2];
            }),
          ],
        ),
      ),
    );
  }
}
