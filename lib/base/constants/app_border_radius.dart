import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App Border Radius - Futuristic soft & rounded corners
class AppBorderRadius {
  static BorderRadius circularXSmall() {
    return BorderRadius.circular(8.r);
  }

  static BorderRadius circularSmall() {
    return BorderRadius.circular(12.r);
  }

  static BorderRadius circularMedium() {
    return BorderRadius.circular(20.r);
  }

  static BorderRadius circularLarge() {
    return BorderRadius.circular(28.r);
  }

  static BorderRadius circularXLarge() {
    return BorderRadius.circular(40.r);
  }

  // Legacy constants for backward compatibility
  static const double small = 12.0;
  static const double middle = 20.0;
  static const double large = 32.0;
}


