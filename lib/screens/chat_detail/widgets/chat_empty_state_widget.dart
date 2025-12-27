import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/chat_style_hud.dart';

class ChatEmptyStateWidget extends StatelessWidget {
  const ChatEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassPanel(
        padding: EdgeInsets.all(32.w),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: ChatHudStyle.glowCyan,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.terminal_rounded, size: 42.sp, color: ChatHudStyle.cyan),
            SizedBox(height: 24.h),
            Text(
              "NO_LOGS_FOUND",
              style: ChatHudStyle.title(16.sp, color: ChatHudStyle.text),
            ),
            SizedBox(height: 8.h),
            Text(
              "Sohbeti başlatmak için bir şeyler yazın.",
              style: ChatHudStyle.label(11.sp, color: ChatHudStyle.dim),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
