import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../constants/chat_style_hud.dart';

class ChatDaySeparatorWidget extends StatelessWidget {
  final DateTime? date;

  const ChatDaySeparatorWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    if (date == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(date!.year, date!.month, date!.day);

    String text;
    if (msgDate == today) {
      text = "SECURE_SESSION_TODAY";
    } else {
      text = DateFormat('dd.MM.yyyy').format(date!);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        children: [
          Expanded(child: _buildDottedLine()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              '// $text',
              style: ChatHudStyle.label(9.sp, color: ChatHudStyle.dim),
            ),
          ),
          Expanded(child: _buildDottedLine()),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return Container(
      height: 1,
      color: ChatHudStyle.cyan.withOpacity(0.15),
    );
  }
}
