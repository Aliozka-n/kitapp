import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:kitapp/base/common_widgets/app_sizeed_box.dart';
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
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(AppText.signIn),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: context.padding.low,
            child: Column(
              children: [
                const AppTextField(
                    hintText: "Kullanıcı Adı", icon: Icons.ac_unit),
                const AppTextField(hintText: "Yaşanılan İl", icon: Icons.home),
                const AppTextField(
                    hintText: "Yaşanılan İlçe",
                    icon: Icons.home_repair_service),
                const AppTextField(hintText: "Email", icon: Icons.email),
                const AppTextField(
                  hintText: "Şifre",
                  icon: Icons.security,
                  isObscureText: true,
                ),
                const AppTextField(
                  hintText: "Şifre",
                  icon: Icons.security,
                  isObscureText: true,
                ),
                AppSizedBox.large,
                AppButton(
                  text: AppText.signIn,
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
