import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../base/constants/app_constants.dart';
import '../base/constants/app_size.dart';

/// Shimmer Widget - Generic shimmer loading effect
class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerWidget({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.greyLight,
      highlightColor: highlightColor ?? AppColors.backgroundWhite,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.sizeMedium.w),
        ),
      ),
    );
  }
}

/// Shimmer Container - Flexible shimmer container
class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Widget? child;

  const ShimmerContainer({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.greyLight,
      highlightColor: highlightColor ?? AppColors.backgroundWhite,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width?.w,
        height: height?.h,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.sizeMedium.w),
        ),
        child: child,
      ),
    );
  }
}

