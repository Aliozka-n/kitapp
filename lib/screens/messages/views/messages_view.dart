import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/messages_view_model.dart';

class MessagesView extends StatelessWidget {
  final MessagesViewModel viewModel;

  const MessagesView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("MESAJLAR"),
      ),
      body: viewModel.messages.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              itemCount: viewModel.messages.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final chat = viewModel.messages[index];
                return _buildChatTile(context, chat);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.primary),
          ),
          SizedBox(height: 24.h),
          Text(
            "HENÜZ MESAJ YOK",
            style: GoogleFonts.syne(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Kitap takası için diğer okurlarla iletişime geç!",
            textAlign: TextAlign.center,
            style: GoogleFonts.instrumentSans(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, dynamic chat) {
    // `chat` burada MessageResponse (MessagesViewModel.messages) beklenir.
    final otherUserId = viewModel.otherUserIdOf(chat);
    final otherUserName = viewModel.otherUserNameOf(chat);

    return InkWell(
      onTap: () {
        NavigationUtil.navigateToChatDetail(
          context,
          otherUserId ?? "",
          otherUserName,
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.primary, width: 1.5),
          boxShadow: AppShadows.sharp,
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: AppColors.accent,
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: const Icon(Icons.person, color: AppColors.textWhite),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserName.toUpperCase(),
                    style: GoogleFonts.syne(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    chat.lastMessage ?? "Mesaj içeriği...",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
