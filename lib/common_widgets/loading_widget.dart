import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/constants/app_constants.dart';
import '../base/constants/app_size.dart';

/// Loading Widget - Modern loading indicator with optional message
class LoadingWidget extends StatelessWidget {
  final double size;
  final String? message;
  final Color? color;

  const LoadingWidget({
    Key? key,
    required this.size,
    this.message,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.w,
            height: size.h,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
              strokeWidth: 4.0,
            ),
          ),
          if (message != null && message!.isNotEmpty) ...[
            SizedBox(height: AppSizes.sizeLarge.h),
            Text(
              message!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
