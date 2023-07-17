import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:kitapp/screens/register/register_screen.dart';

import '../../base/common_widgets/app_button.dart';
import '../../base/common_widgets/app_text_field.dart';
import '../../const/app_colors.dart';
import '../../const/app_edge_insets.dart';
import '../../const/app_font_size.dart';
import '../../const/app_radius.dart';
import '../../const/app_sizes.dart';
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
                width: double.infinity,
                decoration: buildBoxDecoration(),
                child: Padding(
                  padding: context.padding.medium,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(hintText: AppText.email, icon: Icons.email),
                        AppTextField(hintText: AppText.password, icon: Icons.security),
                        buildSizedBox(AppSizes.middle),
                        AppButton(
                          text: AppText.login,
                          context: context,
                          onTap: () {
                            // todo
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                          },
                        ),
                        buildSizedBox(AppSizes.middle),
                        signInButton(context),
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
        padding: EdgeInsets.all(AppEdgeInsets.small),
        height: MediaQuery.of(context).size.height / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Image.asset('assets/icon.jpg'),
        ),
      ),
    );
  }

  Widget signInButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.route.navigateToPage(RegisterPage());
      },
      child: Center(
        child: Text(
          AppText.orSignIn,
          style: TextStyle(
            color: AppColors.blueAccent,
            fontSize: AppFontSize.small,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildSizedBox(double height) {
    return SizedBox(height: height);
  }
}
