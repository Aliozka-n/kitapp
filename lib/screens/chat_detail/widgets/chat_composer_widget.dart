import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/chat_style_hud.dart';

class ChatComposerWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;

  const ChatComposerWidget({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isSending,
  });

  @override
  State<ChatComposerWidget> createState() => _ChatComposerWidgetState();
}

class _ChatComposerWidgetState extends State<ChatComposerWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: GlassPanel(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: ChatHudStyle.glowCyan,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  maxLines: 4,
                  minLines: 1,
                  style: ChatHudStyle.body(14.sp, color: ChatHudStyle.text),
                  cursorWidth: 4,
                  cursorColor: ChatHudStyle.cyan,
                  decoration: InputDecoration(
                    hintText: 'SECURE_CHANNEL://WRITE_MESSAGE',
                    hintStyle: ChatHudStyle.label(11.sp, color: ChatHudStyle.dim),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: widget.isSending ? null : widget.onSend,
      child: Container(
        width: 46.w,
        height: 46.w,
        decoration: BoxDecoration(
          color: ChatHudStyle.cyan,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: ChatHudStyle.glowCyan,
        ),
        child: Center(
          child: widget.isSending
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(ChatHudStyle.space),
                  ),
                )
              : Icon(
                  Icons.send_rounded,
                  color: ChatHudStyle.space,
                  size: 20.sp,
                ),
        ),
      ),
    );
  }
}
