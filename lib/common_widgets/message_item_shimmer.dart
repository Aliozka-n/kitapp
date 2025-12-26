import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/constants/app_size.dart';
import '../base/constants/app_edge_insets.dart';
import 'shimmer_widget.dart';

/// Message Item Shimmer - Loading placeholder for message items
class MessageItemShimmer extends StatelessWidget {
  const MessageItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: AppEdgeInsets.only(bottom: AppSizes.sizeMedium),
      child: Padding(
        padding: AppEdgeInsets.all(AppSizes.sizeMedium),
        child: Row(
          children: [
            // Avatar Shimmer
            ShimmerWidget(
              width: 56.w,
              height: 56.h,
              borderRadius: BorderRadius.circular(28.r),
            ),
            
            SizedBox(width: AppSizes.sizeMedium.w),
            
            // Content Shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Shimmer
                  ShimmerWidget(
                    width: 120.w,
                    height: 18.h,
                    borderRadius: BorderRadius.circular(AppSizes.sizeSmall.w),
                  ),
                  
                  SizedBox(height: AppSizes.sizeXSmall.h),
                  
                  // Message Shimmer
                  ShimmerWidget(
                    width: double.infinity,
                    height: 16.h,
                    borderRadius: BorderRadius.circular(AppSizes.sizeSmall.w),
                  ),
                  
                  SizedBox(height: AppSizes.sizeXSmall.h),
                  
                  // Date Shimmer
                  ShimmerWidget(
                    width: 80.w,
                    height: 14.h,
                    borderRadius: BorderRadius.circular(AppSizes.sizeSmall.w),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

