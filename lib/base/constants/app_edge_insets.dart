import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_size.dart';

/// App Edge Insets - Padding/Margin sabitleri
class AppEdgeInsets {
  static EdgeInsets only({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      top: top?.h ?? 0,
      bottom: bottom?.h ?? 0,
      left: left?.w ?? 0,
      right: right?.w ?? 0,
    );
  }

  static EdgeInsets symmetric({
    double? horizontal,
    double? vertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal?.w ?? 0,
      vertical: vertical?.h ?? 0,
    );
  }

  static EdgeInsets symmetricMedium() {
    return EdgeInsets.symmetric(
      horizontal: AppSizes.sizeMedium.w,
      vertical: AppSizes.sizeMedium.h,
    );
  }

  static EdgeInsets all(double value) {
    return EdgeInsets.all(value.w);
  }

  static EdgeInsets average() {
    return EdgeInsets.all(AppSizes.sizeMedium.w);
  }

  // Eski metodlar (backward compatibility)
  static const double small = 8.0;
  static const double middle = 12.0;
  static const double large = 16.0;
}

