import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/constants/app_constants.dart';
import '../../base/views/base_view.dart';
import 'book_detail_service.dart';
import 'viewmodels/book_detail_view_model.dart';
import 'views/book_detail_view.dart';

/// Book Detail Screen - Modern kitap detay ekranı
class BookDetailScreen extends StatelessWidget {
  final String? bookId;

  const BookDetailScreen({
    Key? key,
    this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: SafeArea(
          child: bookId != null
              ? BaseView<BookDetailViewModel>(
                  vmBuilder: (_) => BookDetailViewModel(
                    service: BookDetailService(),
                    bookId: bookId!,
                  ),
                  builder: (context, viewModel) =>
                      BookDetailView(viewModel: viewModel),
                )
              : Center(
                  child: Text(
                    'Kitap ID bulunamadı',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

}
