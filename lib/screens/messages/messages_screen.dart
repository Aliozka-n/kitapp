import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'messages_service.dart';
import 'viewmodels/messages_view_model.dart';
import 'views/messages_view.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<MessagesViewModel>(
        vmBuilder: (_) => MessagesViewModel(
          service: MessagesService(),
        ),
        builder: (context, viewModel) => MessagesView(viewModel: viewModel),
      ),
    );
  }
}
