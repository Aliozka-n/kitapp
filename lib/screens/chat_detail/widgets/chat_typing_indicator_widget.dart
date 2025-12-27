import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/chat_style_hud.dart';

class ChatTypingIndicatorWidget extends StatefulWidget {
  final String label;

  const ChatTypingIndicatorWidget({super.key, required this.label});

  @override
  State<ChatTypingIndicatorWidget> createState() => _ChatTypingIndicatorWidgetState();
}

class _ChatTypingIndicatorWidgetState extends State<ChatTypingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: ChatHudStyle.label(9.sp, color: ChatHudStyle.cyan),
        ),
        SizedBox(width: 4.w),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final dots = (3 * _controller.value).floor();
            return Text(
              '.' * (dots + 1),
              style: ChatHudStyle.label(12.sp, color: ChatHudStyle.cyan),
            );
          },
        ),
      ],
    );
  }
}
