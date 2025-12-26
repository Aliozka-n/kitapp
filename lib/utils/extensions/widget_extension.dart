import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget Extension - Widget manipülasyonları için
extension WidgetExtension on Widget {
  /// Widget'ı center'a al
  Widget get center => Center(child: this);

  /// Widget'ı expanded yap
  Widget get expanded => Expanded(child: this);

  /// Padding ekle
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value.w),
      child: this,
    );
  }

  /// Symmetric padding ekle
  Widget paddingSymmetric({
    double? horizontal,
    double? vertical,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal?.w ?? 0,
        vertical: vertical?.h ?? 0,
      ),
      child: this,
    );
  }

  /// AppEdgeInsets ile padding ekle
  Widget padding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}

