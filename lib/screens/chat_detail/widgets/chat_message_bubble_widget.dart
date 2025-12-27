import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../base/constants/app_constants.dart';
import '../constants/chat_style_hud.dart';

class ChatMessageBubbleWidget extends StatelessWidget {
  final bool isMe;
  final String text;
  final DateTime time;
  final bool isRead;
  final bool isPending;

  const ChatMessageBubbleWidget({
    super.key,
    required this.isMe,
    required this.text,
    required this.time,
    required this.isRead,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) _buildDirectionLabel('IN'),
              Flexible(
                child: GlassPanel(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(isMe ? 20.r : 4.r),
                    bottomRight: Radius.circular(isMe ? 4.r : 20.r),
                  ),
                  color: isMe 
                      ? ChatHudStyle.indigo.withOpacity(0.15)
                      : AppColors.glassBackground,
                  boxShadow: isMe ? ChatHudStyle.glowIndigo : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: ChatHudStyle.body(
                          14.sp, 
                          color: isMe ? Colors.white : ChatHudStyle.text,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildMeta(),
                    ],
                  ),
                ),
              ),
              if (isMe) _buildDirectionLabel('OUT'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionLabel(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          label,
          style: ChatHudStyle.label(7.sp, color: ChatHudStyle.dim.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildMeta() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('HH:mm').format(time),
          style: ChatHudStyle.mono(9.sp, color: isMe ? Colors.white.withOpacity(0.5) : ChatHudStyle.dim),
        ),
        if (isMe) ...[
          SizedBox(width: 8.w),
          Icon(
            isPending ? Icons.access_time_rounded : Icons.done_all_rounded,
            size: 13.sp,
            color: isRead ? ChatHudStyle.cyan : Colors.white.withOpacity(0.3),
          ),
        ],
      ],
    );
  }

}
