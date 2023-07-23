import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:kitapp/base/common_widgets/app_sizeed_box.dart';
import 'package:kitapp/screens/login/widgets/remember_me.dart';
import 'package:kitapp/screens/login/widgets/sign_in_button.dart';

import '../../base/common_widgets/app_button.dart';
import '../../base/common_widgets/app_text_field.dart';
import '../../const/app_colors.dart';
import '../../const/app_radius.dart';
import '../../const/app_text.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            buildIcon(context),
            Expanded(
              child: Container(
                decoration: buildBoxDecoration(),
                child: Padding(
                  padding: context.padding.medium,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppTextField(
                            hintText: AppText.email, icon: Icons.email),
                        const AppTextField(
                            hintText: AppText.password,
                            icon: Icons.security,
                            isObscureText: true),
                        const RememberMe(),
                        AppSizedBox.small,
                        AppButton(
                          text: AppText.login,
                          onTap: () {
                            // todo
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                          },
                        ),
                        AppSizedBox.middle,
                        const SignInButton(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return const BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    );
  }

  Widget buildIcon(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: context.padding.low,
        height: MediaQuery.of(context).size.height / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Image.asset('assets/icon.jpg'),
        ),
      ),
    );
  }
}
