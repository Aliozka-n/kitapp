import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/chat_style_hud.dart';

class ChatReplyPreviewWidget extends StatelessWidget {
  final String title;
  final String snippet;
  final VoidCallback onClear;

  const ChatReplyPreviewWidget({
    super.key,
    required this.title,
    required this.snippet,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: ChatHudStyle.glowCyan,
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: ChatHudStyle.cyan.withOpacity(0.9),
              borderRadius: BorderRadius.circular(999),
              boxShadow: ChatHudStyle.glowCyan,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ChatHudStyle.label(10.sp, color: ChatHudStyle.cyan),
                ),
                SizedBox(height: 6.h),
                Text(
                  snippet,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ChatHudStyle.body(13.sp, color: ChatHudStyle.text),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: onClear,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 36.w,
              height: 36.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ChatHudStyle.space.withOpacity(0.35),
                border: Border.all(
                  color: ChatHudStyle.cyan.withOpacity(0.35),
                  width: 1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 18.sp, color: ChatHudStyle.text),
            ),
          ),
        ],
      ),
    );
  }
}
