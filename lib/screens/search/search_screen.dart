import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'search_service.dart';
import 'viewmodels/search_view_model.dart';
import 'views/search_view.dart';

/// Search Screen - Arama ekranı wrapper
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<SearchViewModel>(
      vmBuilder: (_) => SearchViewModel(
        service: SearchService(),
      ),
      builder: (context, viewModel) => SearchView(viewModel: viewModel),
    );
  }
}

