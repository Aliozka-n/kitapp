import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'add_book_service.dart';
import 'viewmodels/add_book_view_model.dart';
import 'views/add_book_view.dart';

class AddBookScreen extends StatefulWidget {
  final VoidCallback? onBookAdded;

  const AddBookScreen({super.key, this.onBookAdded});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<AddBookViewModel>(
      vmBuilder: (_) => AddBookViewModel(service: AddBookService()),
      builder: (context, viewModel) => AddBookView(
        viewModel: viewModel,
        onBookAdded: widget.onBookAdded,
      ),
    );
  }
}
