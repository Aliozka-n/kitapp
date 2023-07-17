import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:kitapp/base/common_widgets/app_sizeed_box.dart';
import 'package:kitapp/base/models/book_model.dart';
import 'package:kitapp/const/app_colors.dart';
import 'package:kitapp/const/app_text.dart';

import '../../../base/common_widgets/book.dart';
import '../../../const/app_radius.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.low,
      child: SingleChildScrollView(
        child: Column(children: [
          search(),
          BookWidget(
              bookModel: BookModel(
                  id: "1",
                  lenguage: "tr",
                  name: "deneme",
                  type: "roman",
                  writer: "ali özkan")),
          AppSizedBox.large,
        ]),
      ),
    );
  }

  Container search() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.small),
          color: Colors.black,
          shape: BoxShape.rectangle),
      child: TextField(
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {},
            color: AppColors.primary,
            icon: Icon(Icons.search),
          ),
          prefixIcon: Icon(
            Icons.ac_unit,
            color: AppColors.primary,
          ),
          hintText: AppText.bookName,
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
