import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../const/app_colors.dart';
import '../../const/app_font_size.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.buttonColor = AppColors.black,
    this.textColor = AppColors.primary,
    required this.onTap,
  });
  final String text;
  final Color buttonColor;
  final Color textColor;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: buttonColor,
        ),
        child: Center(
          child: Padding(
            padding: context.padding.low,
            child: Text(
              text,
              style: textStyle(),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return TextStyle(
      color: textColor,
      fontSize: AppFontSize.xlarge,
      fontWeight: FontWeight.w500,
    );
  }
}
