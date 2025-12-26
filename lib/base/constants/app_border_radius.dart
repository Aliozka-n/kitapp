import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_size.dart';

/// App Border Radius - Border radius sabitleri
class AppBorderRadius {
  static BorderRadius circularXSmall() {
    return BorderRadius.circular(AppSizes.sizeXSmall.w);
  }

  static BorderRadius circularSmall() {
    return BorderRadius.circular(AppSizes.sizeSmall.w);
  }

  static BorderRadius circularMedium() {
    return BorderRadius.circular(AppSizes.sizeMedium.w);
  }

  static BorderRadius circularLarge() {
    return BorderRadius.circular(AppSizes.sizeLarge.w);
  }

  static BorderRadius circularXLarge() {
    return BorderRadius.circular(AppSizes.sizeXLarge.w);
  }

  // Eski metodlar (backward compatibility)
  static const double small = 10.0;
  static const double middle = 20.0;
  static const double large = 30.0;
}

