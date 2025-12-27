import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/chat_style_hud.dart';

class ChatJumpToBottomWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool show;

  const ChatJumpToBottomWidget({
    super.key,
    required this.onTap,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      offset: show ? Offset.zero : const Offset(0, 0.35),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 140),
        opacity: show ? 1 : 0,
        child: IgnorePointer(
          ignoring: !show,
          child: Align(
            alignment: Alignment.centerRight,
            child: GlassPanel(
              borderRadius: BorderRadius.circular(999),
              boxShadow: ChatHudStyle.glowCyan,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.keyboard_double_arrow_down_rounded,
                        size: 20.sp,
                        color: ChatHudStyle.cyan,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'EN ALTA İN',
                        style: ChatHudStyle.label(10.sp, color: ChatHudStyle.text),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
