import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'book_detail_service.dart';
import 'viewmodels/book_detail_view_model.dart';
import 'views/book_detail_view.dart';

class BookDetailScreen extends StatelessWidget {
  final String? bookId;

  const BookDetailScreen({
    Key? key,
    this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bookId != null
          ? BaseView<BookDetailViewModel>(
              vmBuilder: (_) => BookDetailViewModel(
                service: BookDetailService(),
                bookId: bookId!,
              ),
              builder: (context, viewModel) =>
                  BookDetailView(viewModel: viewModel),
            )
          : Container(),
    );
  }
}
