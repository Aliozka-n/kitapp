import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/constants/app_constants.dart';
import '../base/constants/app_size.dart';
import '../base/constants/app_edge_insets.dart';
import 'shimmer_widget.dart';

/// Book Card Shimmer - Loading placeholder for book cards
class BookCardShimmer extends StatelessWidget {
  const BookCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Shimmer - Flexible ile sınırlandırıldı
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.sizeLarge.w),
                topRight: Radius.circular(AppSizes.sizeLarge.w),
              ),
              child: ShimmerContainer(
                width: double.infinity,
                height: 150.h,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.sizeLarge.w),
                  topRight: Radius.circular(AppSizes.sizeLarge.w),
                ),
              ),
            ),
          ),
          
          // Content Shimmer
          Expanded(
            child: Padding(
              padding: AppEdgeInsets.all(AppSizes.sizeMedium),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Shimmer
                  ShimmerWidget(
                    width: double.infinity,
                    height: 18.h,
                    borderRadius: BorderRadius.circular(AppSizes.sizeSmall.w),
                  ),
                  
                  SizedBox(height: AppSizes.sizeXSmall.h),
                  
                  // Subtitle Shimmer
                  ShimmerWidget(
                    width: 100.w,
                    height: 14.h,
                    borderRadius: BorderRadius.circular(AppSizes.sizeSmall.w),
                  ),
                  
                  const Spacer(),
                  
                  // Tags Shimmer
                  Row(
                    children: [
                      ShimmerWidget(
                        width: 50.w,
                        height: 20.h,
                        borderRadius: BorderRadius.circular(AppSizes.sizeSmall.w),
                      ),
                      SizedBox(width: AppSizes.sizeSmall.w),
                      ShimmerWidget(
                        width: 35.w,
                        height: 14.h,
                        borderRadius: BorderRadius.circular(AppSizes.sizeSmall.w),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

