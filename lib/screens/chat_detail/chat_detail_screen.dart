import 'package:flutter/material.dart';
import '../../base/constants/app_constants.dart';
import '../../base/views/base_view.dart';
import 'chat_detail_service.dart';
import 'viewmodels/chat_detail_view_model.dart';
import 'views/chat_detail_view.dart';

/// Chat Detail Screen - Modern mesajlaşma detay ekranı
class ChatDetailScreen extends StatelessWidget {
  final String receiverId;
  final String receiverName;

  const ChatDetailScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: SafeArea(
          child: BaseView<ChatDetailViewModel>(
            vmBuilder: (_) => ChatDetailViewModel(
              service: ChatDetailService(),
              receiverId: receiverId,
              receiverName: receiverName,
            ),
            builder: (context, viewModel) => const ChatDetailView(),
          ),
        ),
      ),
    );
  }
}
