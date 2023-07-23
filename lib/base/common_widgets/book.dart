import 'package:flutter/material.dart';
import 'package:kitapp/base/models/book_model.dart';
import 'package:kitapp/const/app_radius.dart';

import '../../const/app_colors.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({super.key, this.bookModel, this.onTap});
  final BookModel? bookModel;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    if (!isBookModelValid(bookModel)) return const SizedBox();
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.large),
      highlightColor: AppColors.primary,
      onTap: onTap,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.large))),
        color: AppColors.black,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.book,
              color: AppColors.white,
            ),
          ),
          trailing: const Icon(
            Icons.touch_app_rounded,
            color: AppColors.primary,
          ),
          textColor: AppColors.white,
          title: Text(bookModel!.name ?? ""),
          subtitle: Text(bookModel!.writer ?? ""),
        ),
      ),
    );
  }

  bool isBookModelValid(BookModel? bookModel) {
    return bookModel?.id != null &&
        bookModel?.lenguage != null &&
        bookModel?.name != null &&
        bookModel?.type != null &&
        bookModel?.writer != null;
  }
}
