import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../base/constants/app_constants.dart';
import '../base/common_widgets/glass_container.dart';

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class FuturisticBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const FuturisticBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        bottom: 24.h + MediaQuery.of(context).padding.bottom,
      ),
      child: GlassContainer(
        borderRadius: 32.r,
        opacity: 0.12,
        blur: 16,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isActive = index == currentIndex;
            
            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: isActive ? 20.w : 12.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  gradient: isActive ? AppGradients.cosmic : null,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: isActive ? AppShadows.glow : [],
                ),
                child: Row(
                  children: [
                    Icon(
                      isActive ? item.activeIcon : item.icon,
                      size: 24.sp,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                    ),
                    if (isActive) ...[
                      SizedBox(width: 10.w),
                      Text(
                        item.label,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
