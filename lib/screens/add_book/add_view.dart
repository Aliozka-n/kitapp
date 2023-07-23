import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:kitapp/base/common_widgets/app_button.dart';
import 'package:kitapp/base/common_widgets/app_sizeed_box.dart';
import 'package:kitapp/base/common_widgets/app_text_field.dart';
import 'package:kitapp/const/app_colors.dart';
import 'package:kitapp/const/app_text.dart';

class AddView extends StatelessWidget {
  const AddView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const AppTextField(hintText: AppText.bookName, icon: Icons.book),
          const AppTextField(hintText: AppText.writerName, icon: Icons.book),
          const AppTextField(
              hintText: AppText.bookType, icon: Icons.abc_rounded),
          const AppTextField(
              hintText: AppText.bookLanguage, icon: Icons.abc_rounded),
          AppSizedBox.large,
          Padding(
            padding: context.padding.low,
            child: AppButton(
              text: AppText.save,
              onTap: () {},
            ),
          ),
          AppSizedBox.large,
        ],
      ),
    );
  }
}
