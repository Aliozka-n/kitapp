import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:kitapp/base/common_widgets/app_button.dart';
import 'package:kitapp/base/common_widgets/app_sizeed_box.dart';
import 'package:kitapp/const/app_colors.dart';

import '../../base/common_widgets/side_by_side_text_field.dart';

class BookDetailScreen extends StatelessWidget {
  BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kitap Detay")),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.padding.low,
          child: Column(
            children: [
              bookName,
              writerName,
              bookType,
              province,
              district,
              AppSizedBox.large,
              AppButton(
                onTap: () {},
                text: 'İletişime Geç',
              )
            ],
          ),
        ),
      ),
    );
  }

  SideBySideTextFields bookName = SideBySideTextFields(
    onPressed: () {},
    labelOne: "Kitap Adı",
    labelTwo: "Deneme",
    isEdit: false,
  );
  SideBySideTextFields writerName = SideBySideTextFields(
    onPressed: () {},
    labelOne: "Yazar Adı",
    labelTwo: "Ali özkan",
    isEdit: false,
  );
  SideBySideTextFields bookType = SideBySideTextFields(
    onPressed: () {},
    labelOne: "Türü",
    labelTwo: "Roman",
    isEdit: false,
  );
  SideBySideTextFields province = SideBySideTextFields(
    onPressed: () {},
    labelOne: "İl",
    labelTwo: "Denizli",
    isEdit: false,
  );
  SideBySideTextFields district = SideBySideTextFields(
    onPressed: () {},
    labelOne: "İlçe",
    labelTwo: "Çivril",
    isEdit: false,
  );
}
