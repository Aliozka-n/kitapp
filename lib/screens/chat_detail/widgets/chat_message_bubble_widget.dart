import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(isMe ? 16.r : 2.r),
                    bottomRight: Radius.circular(isMe ? 2.r : 16.r),
                  ),
                  boxShadow: isMe ? ChatHudStyle.glowCyan : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style:
                            ChatHudStyle.body(14.sp, color: ChatHudStyle.text),
                      ),
                      SizedBox(height: 6.h),
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
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          label,
          style: ChatHudStyle.label(8.sp, color: ChatHudStyle.dim),
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
          style: ChatHudStyle.mono(9.sp, color: ChatHudStyle.dim),
        ),
        if (isMe) ...[
          SizedBox(width: 6.w),
          Icon(
            isPending ? Icons.access_time : Icons.done_all,
            size: 12.sp,
            color: isRead ? ChatHudStyle.cyan : ChatHudStyle.dim,
          ),
        ],
      ],
    );
  }
}
