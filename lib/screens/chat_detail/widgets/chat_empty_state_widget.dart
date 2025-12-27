import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/chat_style_hud.dart';

class ChatEmptyStateWidget extends StatelessWidget {
  const ChatEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ChatHudStyle.cyan.withOpacity(0.1),
              border: Border.all(color: ChatHudStyle.cyan.withOpacity(0.2)),
            ),
            child: Icon(Icons.forum_outlined,
                size: 42.sp, color: ChatHudStyle.cyan),
          ),
          SizedBox(height: 24.h),
          Text(
            "HENÜZ MESAJ YOK",
            style: ChatHudStyle.title(16.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            "Sohbeti başlatmak için bir şeyler yazın.",
            style: ChatHudStyle.label(12.sp, color: ChatHudStyle.dim),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
