import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:kitapp/base/common_widgets/app_sizeed_box.dart';
import 'package:kitapp/const/app_colors.dart';
import 'package:kitapp/const/app_sizes.dart';

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

class SideBySideTextFields extends StatelessWidget {
  final String? labelOne;
  final String? labelTwo;
  final void Function()? onPressed;

  const SideBySideTextFields({
    Key? key,
    this.labelOne,
    this.labelTwo,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.padding.low,
      margin: EdgeInsets.only(top: AppSizes.small),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$labelOne  :",
              style: TextStyle(color: AppColors.white),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              labelTwo ?? "",
              style: TextStyle(color: AppColors.white),
            ),
          ),
          Expanded(
              flex: 1,
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.edit, color: AppColors.white),
              )),
        ],
      ),
    );
  }
}
