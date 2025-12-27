import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../base/constants/app_constants.dart';

class InkwellBottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const InkwellBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class InkwellBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<InkwellBottomNavItem> items;

  const InkwellBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final height = (64.h + safeBottom).clamp(64.h, 92.h);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border(
          top: BorderSide(
            color: AppColors.primary.withOpacity(0.12),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 24.r,
            offset: Offset(0, -10.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavTile(
                    item: items[i],
                    isActive: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final InkwellBottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = item.label.toUpperCase();

    return Semantics(
      button: true,
      selected: isActive,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.accent.withOpacity(0.12),
          highlightColor: AppColors.accent.withOpacity(0.06),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: isActive ? AppColors.backgroundLight : Colors.transparent,
                border: Border.all(
                  color: isActive
                      ? AppColors.primary.withOpacity(0.18)
                      : Colors.transparent,
                  width: 1,
                ),
                boxShadow: isActive ? AppShadows.sharp : AppShadows.none,
              ),
              child: Stack(
                children: [
                  // Active marker: sharp "ink" notch
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      height: isActive ? 3.h : 0,
                      color: isActive ? AppColors.primary : Colors.transparent,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? item.activeIcon : item.icon,
                          size: 22.sp,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.greyDark,
                        ),
                        SizedBox(height: 6.h),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          style: GoogleFonts.syne(
                            fontSize: 10.sp,
                            fontWeight:
                                isActive ? FontWeight.w800 : FontWeight.w700,
                            letterSpacing: 1.2,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.greyDark,
                          ),
                          child: Text(label, maxLines: 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


