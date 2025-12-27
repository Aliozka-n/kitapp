import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';

class ProfileEmptyStateWidget extends StatelessWidget {
  final String message;

  const ProfileEmptyStateWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40.sp, color: AppColors.primary),
          SizedBox(height: 16.h),
          Text(
            message,
            style: GoogleFonts.instrumentSans(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
