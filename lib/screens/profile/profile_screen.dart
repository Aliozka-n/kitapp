import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:kitapp/base/common_widgets/app_sizeed_box.dart';
import 'package:kitapp/const/app_colors.dart';

import '../../base/common_widgets/side_by_side_text_field.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: context.padding.low,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 75,
              backgroundImage: AssetImage('assets/icon.jpg'),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            AppSizedBox.large,
            SideBySideTextFields(
              labelOne: "Kullanıcı Adı",
              labelTwo: "Ali Özkan",
              onPressed: () {},
            ),
            SideBySideTextFields(
              labelOne: "E-mail",
              labelTwo: "aliozkan@gmail.com",
              onPressed: () {},
            ),
            SideBySideTextFields(
              labelOne: "İl",
              labelTwo: "Denizli",
              onPressed: () {},
            ),
            SideBySideTextFields(
              labelOne: "İlçe",
              labelTwo: "Çivril",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
