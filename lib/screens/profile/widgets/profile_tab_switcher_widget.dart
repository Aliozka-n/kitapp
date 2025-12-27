import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';

class ProfileTabSwitcherWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const ProfileTabSwitcherWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTab("KİTAPLARIM", 0),
        SizedBox(width: 16.w),
        _buildTab("FAVORİLERİM", 1),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.backgroundWhite,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.syne(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: isSelected ? AppColors.textWhite : AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
