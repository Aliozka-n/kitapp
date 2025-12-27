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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundCanvas,
            AppColors.primary,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "MESAJLAR",
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
        ),
        body: viewModel.messages.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 16.h,
                  bottom: 140.h, // Space for futuristic bottom nav bar
                ),
                itemCount: viewModel.messages.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final chat = viewModel.messages[index];
                  return _buildChatTile(context, chat);
                },
              ),
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
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
            ),
            child: Icon(Icons.chat_bubble_rounded, size: 64.sp, color: AppColors.accentCyan),
          ),
          SizedBox(height: 24.h),
          Text(
            "HENÜZ MESAJ YOK",
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "Kitap takası için diğer okurlarla iletişime geç!",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, dynamic chat) {
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
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 54.w,
              height: 54.w,
              decoration: BoxDecoration(
                gradient: AppGradients.cosmic,
                shape: BoxShape.circle,
                boxShadow: AppShadows.glow,
              ),
              child: const Center(child: Icon(Icons.person_rounded, color: AppColors.textWhite)),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserName,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    chat.lastMessage ?? "Mesaj içeriği...",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20.sp, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
