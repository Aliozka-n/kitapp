import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:kitapp/base/common_widgets/app_sizebox.dart';
import 'package:kitapp/base/common_widgets/app_text_field.dart';
import 'package:kitapp/const/app_colors.dart';

import '../../base/common_widgets/app_button.dart';
import '../../const/app_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primary),
        body: SingleChildScrollView(
          child: Padding(
            padding: context.padding.low,
            child: Column(
              children: [
                AppSizedBox.middle,
                AppTextField(hintText: "Kullanıcı Adı", icon: Icons.ac_unit),
                AppSizedBox.small,
                AppTextField(hintText: "Yaşanılan İl", icon: Icons.home),
                AppSizedBox.small,
                AppTextField(hintText: "Yaşanılan İlçe", icon: Icons.home_repair_service),
                AppSizedBox.small,
                AppTextField(hintText: "Email", icon: Icons.email),
                AppSizedBox.small,
                AppTextField(hintText: "Şifre", icon: Icons.security),
                AppSizedBox.small,
                AppTextField(hintText: "Şifre", icon: Icons.security),
                AppSizedBox.large,
                AppButton(
                  text: AppText.signIn,
                  context: context,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
