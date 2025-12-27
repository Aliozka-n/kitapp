import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base/constants/app_constants.dart';
import '../constants/chat_style_hud.dart';

class ChatAppBarWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const ChatAppBarWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        bottom: 16.h,
        left: 8.w,
        right: 20.w,
      ),
      borderRadius: BorderRadius.zero,
      boxShadow: ChatHudStyle.glowCyan,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back_ios_new,
                size: 18.sp, color: ChatHudStyle.cyan),
          ),
          SizedBox(width: 4.w),
          _buildAvatar(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ChatHudStyle.title(16.sp),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: AppColors.successColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      subtitle.toUpperCase(),
                      style: ChatHudStyle.label(9.sp, color: ChatHudStyle.cyan),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildActionIcon(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppGradients.cosmic,
        boxShadow: AppShadows.glow,
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
      ),
      child: Center(
        child: Text(
          title.isNotEmpty ? title[0].toUpperCase() : "?",
          style: ChatHudStyle.title(18.sp, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActionIcon() {
    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        color: Colors.white.withOpacity(0.03),
      ),
      child: Center(
        child: Icon(
          Icons.more_vert_rounded,
          size: 20.sp,
          color: ChatHudStyle.dim,
        ),
      ),
    );
  }

}
