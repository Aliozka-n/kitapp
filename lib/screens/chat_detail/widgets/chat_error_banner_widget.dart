import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/chat_style_hud.dart';

class ChatErrorBannerWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ChatErrorBannerWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.all(16.w),
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: ChatHudStyle.glowPink,
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: ChatHudStyle.pink, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SYSTEM_ERROR',
                  style: ChatHudStyle.label(10.sp, color: ChatHudStyle.pink),
                ),
                Text(
                  message,
                  style: ChatHudStyle.body(12.sp, color: ChatHudStyle.text),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'RETRY',
              style: ChatHudStyle.label(12.sp, color: ChatHudStyle.cyan),
            ),
          ),
        ],
      ),
    );
  }
}
