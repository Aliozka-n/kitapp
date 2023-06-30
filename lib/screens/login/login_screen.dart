import 'package:flutter/material.dart';
import 'package:kitapp/const/app_colors.dart';
import 'package:kitapp/const/app_edge_insets.dart';
import 'package:kitapp/const/app_font_size.dart';
import 'package:kitapp/const/app_radius.dart';
import 'package:kitapp/const/app_sizes.dart';

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
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInput(hintText: "Email", upText: "Email"),
                        buildSizedBox(AppSizes.small),
                        buildInput(hintText: "Password", upText: "Password"),
                        buildSizedBox(AppSizes.large),
                        loginButton(),
                        buildSizedBox(AppSizes.middle),
                        signInButton(),
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

  Widget buildInput({required String upText, required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          upText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: AppFontSize.large,
            fontWeight: FontWeight.bold,
          ),
        ),
        buildSizedBox(AppSizes.small),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.small),
            color: Colors.black,
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.email,
                color: AppColors.primary,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIcon(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.all(AppEdgeInsets.small),
        height: MediaQuery.of(context).size.height / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Image.asset('assets/icon.jpg'),
        ),
      ),
    );
  }

  Widget loginButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black,
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Log In',
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppFontSize.xlarge,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signInButton() {
    return InkWell(
      onTap: () {},
      child: const Center(
        child: Text(
          'Or Sign In',
          style: TextStyle(
            color: Colors.blue,
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
