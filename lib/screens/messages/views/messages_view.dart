import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/constants/app_size.dart';
import '../../../base/constants/app_edge_insets.dart';
import '../../../common_widgets/empty_state_widget.dart';
import '../../../common_widgets/error_state_widget.dart';
import '../../../common_widgets/message_item_shimmer.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/messages_view_model.dart';

/// Messages View - List of all message conversations
class MessagesView extends StatelessWidget {
  final MessagesViewModel viewModel;

  const MessagesView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(context),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.loadMessages(),
        child: _buildMessagesList(context),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
      ),
      child: TextField(
        controller: viewModel.searchController,
        onChanged: (value) {
          viewModel.updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Mesajlarda ara...',
          hintStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 20.sp,
          ),
          suffixIcon: viewModel.searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    viewModel.clearSearch();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: AppEdgeInsets.symmetric(
            horizontal: AppSizes.sizeMedium,
            vertical: AppSizes.sizeSmall,
          ),
        ),
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context) {
    // Loading State with Shimmer
    if (viewModel.isLoading && viewModel.messages.isEmpty) {
      return ListView.builder(
        padding: AppEdgeInsets.all(AppSizes.sizeMedium),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: 5, // Show 5 shimmer items
        itemBuilder: (context, index) {
          return MessageItemShimmer();
        },
      );
    }

    // Error State
    if (viewModel.errorMessage != null) {
      return ErrorStateWidget.generic(
        title: 'Hata Oluştu',
        message: viewModel.errorMessage!,
        onRetry: () => viewModel.loadMessages(),
      );
    }

    final messages = viewModel.messages;

    // Empty State
    if (messages.isEmpty) {
      if (viewModel.searchQuery.isNotEmpty) {
        return EmptyStateWidget.noSearchResults(
          onAction: () => viewModel.clearSearch(),
        );
      }
      return EmptyStateWidget.noMessages();
    }

    // Messages List
    return ListView.builder(
      padding: AppEdgeInsets.all(AppSizes.sizeMedium),
      physics: AlwaysScrollableScrollPhysics(), // Pull-to-refresh için gerekli
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageItem(context, message);
      },
    );
  }

  Widget _buildMessageItem(BuildContext context, message) {
    return Dismissible(
      key: Key(message.id ?? DateTime.now().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: AppEdgeInsets.symmetric(horizontal: AppSizes.sizeLarge),
        decoration: BoxDecoration(
          color: AppColors.errorColor,
          borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
        ),
        child: Icon(
          Icons.delete,
          color: AppColors.textWhite,
          size: 24.sp,
        ),
      ),
      confirmDismiss: (direction) async {
        // Onay diyaloğu göster
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Mesajı Sil'),
            content: Text('Bu mesajı silmek istediğinize emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('İptal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.errorColor,
                ),
                child: Text('Sil'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) async {
        if (message.id != null) {
          await viewModel.deleteMessage(message.id!);
        }
      },
      child: Card(
        margin: AppEdgeInsets.only(bottom: AppSizes.sizeMedium),
        child: ListTile(
        contentPadding: AppEdgeInsets.all(AppSizes.sizeMedium),
        leading: CircleAvatar(
          radius: 28.r,
          backgroundColor: AppColors.primary,
          child: Text(
            (message.userName ?? 'U')[0].toUpperCase(),
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(
          message.userName ?? 'Kullanıcı',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.sizeXSmall.h),
            Text(
              message.lastMessage ?? '',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSizes.sizeXSmall.h),
            Text(
              message.date ?? '',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        trailing: message.isRead == false
            ? Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // Diğer kullanıcının ID'sini bul
          final currentUserId = Supabase.instance.client.auth.currentUser?.id;
          final otherUserId = message.senderId == currentUserId
              ? message.receiverId
              : message.senderId;
          
          // Kullanıcı adını al (message.userName veya cache'den)
          final userName = message.userName ?? 'Kullanıcı';
          
          if (otherUserId != null) {
            NavigationUtil.navigateToChatDetail(
              context,
              receiverId: otherUserId,
              receiverName: userName,
            );
          }
        },
      ),
      ),
    );
  }
}
