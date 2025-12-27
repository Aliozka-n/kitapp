import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  title.toUpperCase(),
                  style: ChatHudStyle.title(16.sp),
                ),
                Text(
                  subtitle.toUpperCase(),
                  style: ChatHudStyle.label(10.sp, color: ChatHudStyle.dim),
                ),
              ],
            ),
          ),
          _buildStatusIndicator(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 42.w,
      height: 42.w,
      decoration: BoxDecoration(
        color: ChatHudStyle.space,
        border: Border.all(color: ChatHudStyle.cyan.withOpacity(0.5), width: 1),
      ),
      child: Center(
        child: Text(
          title.isNotEmpty ? title[0].toUpperCase() : "?",
          style: ChatHudStyle.title(20.sp),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        border: Border.all(color: ChatHudStyle.cyan.withOpacity(0.3)),
      ),
      child: Center(
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: ChatHudStyle.cyan,
            boxShadow: ChatHudStyle.glowCyan,
          ),
        ),
      ),
    );
  }
}
