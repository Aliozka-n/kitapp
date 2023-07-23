import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../const/app_colors.dart';
import '../../const/app_font_size.dart';
import '../../const/app_radius.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      required this.hintText,
      this.icon,
      this.isObscureText = false});
  final String hintText;
  final IconData? icon;
  final bool isObscureText;
  @override
  Widget build(BuildContext context) {
    return buildInput(context, hintText: hintText);
  }

  Widget buildInput(BuildContext context,
      {required String hintText,
      Color background = AppColors.black,
      Color textColor = AppColors.white}) {
    return Padding(
      padding: context.padding.low,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: TextStyle(
              color: background,
              fontSize: AppFontSize.large,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.small),
              color: background,
            ),
            child: TextField(
              textInputAction: TextInputAction.next,
              obscureText: isObscureText,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  icon,
                  color: AppColors.primary,
                ),
                hintText: hintText,
                hintStyle: TextStyle(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
