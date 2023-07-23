import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../const/app_colors.dart';
import '../../../const/app_font_size.dart';
import '../../../const/app_text.dart';
import '../../register/register_screen.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.route.navigateToPage(const RegisterPage());
      },
      child: const Center(
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
}
