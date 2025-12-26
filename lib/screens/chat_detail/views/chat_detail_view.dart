import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/constants/app_size.dart';
import '../../../base/constants/app_edge_insets.dart';
import '../../../base/constants/app_texts.dart';
import '../../../common_widgets/empty_state_widget.dart';
import '../../../common_widgets/error_state_widget.dart';
import '../viewmodels/chat_detail_view_model.dart';

/// Chat Detail View - Detailed chat screen with a specific user
class ChatDetailView extends StatelessWidget {
  const ChatDetailView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Consumer'dan viewModel'i al
    return Consumer<ChatDetailViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              viewModel.receiverName,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.backgroundWhite,
            elevation: 0,
          ),
          body: Column(
            children: [
              // Messages List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => viewModel.refresh(),
                  child: _buildMessagesList(context),
                ),
              ),
              
              // Message Input
              _buildMessageInput(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessagesList(BuildContext context) {
    // Consumer'dan viewModel'i al
    final viewModel = Provider.of<ChatDetailViewModel>(context, listen: true);
    
    // Error State
    if (viewModel.errorMessage != null && viewModel.messages.isEmpty) {
      return ErrorStateWidget.generic(
        title: 'Hata Oluştu',
        message: viewModel.errorMessage!,
        onRetry: () => viewModel.loadMessages(),
      );
    }

    final messages = viewModel.messages;

    // Empty State
    if (messages.isEmpty) {
      return EmptyStateWidget.generic(
        icon: Icons.message_outlined,
        title: 'Henüz mesaj yok',
        message: 'İlk mesajınızı göndererek sohbete başlayın',
      );
    }

    return ListView.builder(
      key: ValueKey('messages_list_${messages.length}'), // Liste değiştiğinde rebuild et
      controller: viewModel.scrollController,
      padding: AppEdgeInsets.all(AppSizes.sizeMedium),
      reverse: false,
      physics: const AlwaysScrollableScrollPhysics(), // Pull-to-refresh için gerekli
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(
          context, 
          message,
          key: ValueKey('message_${message.id}_${index}'), // Her mesaj için unique key
        );
      },
    );
  }

  Widget _buildMessageBubble(BuildContext context, message, {Key? key}) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isMe = message.senderId == currentUserId;
    
    // Tarih formatla - önce createdAt, sonra date kullan
    String formattedDate = '';
    DateTime? messageDate;
    
    // Önce createdAt'i kontrol et (Supabase'den gelir)
    if (message.createdAt != null) {
      messageDate = message.createdAt;
    } else if (message.date != null) {
      // Eğer createdAt yoksa date'i parse et
      try {
        messageDate = DateTime.parse(message.date!);
      } catch (e) {
        // Parse edilemezse boş bırak
      }
    }
    
    if (messageDate != null) {
      final now = DateTime.now();
      final difference = now.difference(messageDate);
      
      if (difference.inDays == 0) {
        // Bugün - sadece saat göster
        formattedDate = '${messageDate.hour.toString().padLeft(2, '0')}:${messageDate.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        formattedDate = 'Dün ${messageDate.hour.toString().padLeft(2, '0')}:${messageDate.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays < 7) {
        formattedDate = '${difference.inDays} gün önce';
      } else {
        formattedDate = '${messageDate.day}/${messageDate.month}/${messageDate.year}';
      }
    }
    
    return Align(
      key: key,
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: AppEdgeInsets.only(bottom: AppSizes.sizeSmall),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppEdgeInsets.all(AppSizes.sizeMedium),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : AppColors.greyLight,
                borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
              ),
              child: Text(
                message.lastMessage ?? '',
                style: TextStyle(
                  color: isMe ? AppColors.textWhite : AppColors.textPrimary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (formattedDate.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Padding(
                padding: AppEdgeInsets.symmetric(horizontal: AppSizes.sizeSmall),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    // Consumer'dan viewModel'i al
    final viewModel = Provider.of<ChatDetailViewModel>(context, listen: false);
    
    return Container(
      padding: AppEdgeInsets.all(AppSizes.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: viewModel.messageController,
              decoration: InputDecoration(
                hintText: AppTexts.typeMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.greyLight,
                contentPadding: AppEdgeInsets.symmetric(
                  horizontal: AppSizes.sizeLarge,
                  vertical: AppSizes.sizeMedium,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => viewModel.sendMessage(),
            ),
          ),
          SizedBox(width: AppSizes.sizeSmall.w),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.primary),
            onPressed: () => viewModel.sendMessage(),
          ),
        ],
      ),
    );
  }
}
