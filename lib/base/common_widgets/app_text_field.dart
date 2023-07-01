import 'package:flutter/material.dart';

import '../../const/app_colors.dart';
import '../../const/app_font_size.dart';
import '../../const/app_radius.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({super.key, required this.hintText, required this.icon});
  final String hintText;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return buildInput(hintText: hintText);
  }

  Widget buildInput(
      {required String hintText,
      Color background = AppColors.black,
      Color textColor = AppColors.white}) {
    return Column(
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
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.small),
            color: background,
          ),
          child: TextField(
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
    );
  }
}
