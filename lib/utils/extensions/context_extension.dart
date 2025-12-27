import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/constants/app_constants.dart';

/// BuildContext Extension - Tema ve medya sorgularına erişim
extension BuildContextExtension on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  Color get primaryColor => Theme.of(this).primaryColor;
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
}

/// TextStyle Extension - Standart text stilleri
extension TextStyleExtension on BuildContext {
  TextStyle get textStyle => textTheme.bodySmall!.copyWith(
        fontSize: 14.sp,
        color: AppColors.textPrimary,
      );

  TextStyle get hintTextStyle => textTheme.bodySmall!.copyWith(
        fontSize: 13.sp,
        color: AppColors.grey,
      );

  TextStyle get titleTextStyle => textTheme.titleLarge!.copyWith(
        fontSize: 18.sp,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      );
}


