import 'package:flutter/material.dart';
import 'package:kitapp/base/models/book_model.dart';

import '../../const/app_colors.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({super.key, this.bookModel});
  final BookModel? bookModel;

  @override
  Widget build(BuildContext context) {
    if (bookModel?.id == null) return const SizedBox();
    if (bookModel?.lenguage == null) return const SizedBox();
    if (bookModel?.name == null) return const SizedBox();
    if (bookModel?.type == null) return const SizedBox();
    if (bookModel?.writer == null) return const SizedBox();
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
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
          Icons.navigate_next,
          color: AppColors.primary,
        ),
        textColor: AppColors.white,
        title: Text(bookModel!.name ?? ""),
        subtitle: Text(bookModel!.writer ?? ""),
      ),
    );
  }
}
