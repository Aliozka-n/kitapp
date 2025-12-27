import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base/constants/app_constants.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: ChatHudStyle.glowIndigo,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildIconButton(Icons.add_rounded),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: widget.controller,
                    maxLines: 4,
                    minLines: 1,
                    style: ChatHudStyle.body(14.sp, color: ChatHudStyle.text),
                    cursorWidth: 2,
                    cursorColor: ChatHudStyle.cyan,
                    decoration: InputDecoration(
                      hintText: 'Bir mesaj yaz...',
                      hintStyle: ChatHudStyle.body(14.sp, color: ChatHudStyle.dim),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 44.w,
      height: 44.w,
      margin: EdgeInsets.only(bottom: 2.h),
      child: Center(
        child: Icon(icon, color: ChatHudStyle.dim, size: 24.sp),
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: widget.isSending ? null : widget.onSend,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48.w,
        height: 48.w,
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          gradient: AppGradients.cosmic,
          shape: BoxShape.circle,
          boxShadow: AppShadows.glow,
        ),
        child: Center(
          child: widget.isSending
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
        ),
      ),
    );
  }

}
