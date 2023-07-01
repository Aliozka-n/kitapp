import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../const/app_colors.dart';
import '../../const/app_font_size.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.context,
    this.buttonColor = AppColors.black,
    this.textColor = AppColors.white,
    required this.onTap,
  });
  final String text;
  final BuildContext context;
  final Color buttonColor;
  final Color textColor;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return loginButton(text: text);
  }

  Widget loginButton({required String text}) {
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
              style: TextStyle(
                color: textColor,
                fontSize: AppFontSize.xlarge,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
