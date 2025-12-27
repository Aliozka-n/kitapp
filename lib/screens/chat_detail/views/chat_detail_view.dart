import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../../base/constants/app_edge_insets.dart';
import '../../../domain/dtos/message_dto.dart';
import '../viewmodels/chat_detail_view_model.dart';
import '../constants/chat_style_hud.dart';
import '../widgets/chat_app_bar_widget.dart';
import '../widgets/chat_composer_widget.dart';
import '../widgets/chat_day_separator_widget.dart';
import '../widgets/chat_empty_state_widget.dart';
import '../widgets/chat_error_banner_widget.dart';
import '../widgets/chat_message_bubble_widget.dart';
import '../widgets/chat_typing_indicator_widget.dart';
import '../widgets/chat_jump_to_bottom_widget.dart';
import '../widgets/chat_reply_preview_widget.dart';

class ChatDetailView extends StatefulWidget {
  final ChatDetailViewModel viewModel;

  const ChatDetailView({
    super.key,
    required this.viewModel,
  });

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final ValueNotifier<bool> _showJump = ValueNotifier<bool>(false);
  String? _replySnippet;
  bool _isReplyToMe = false;

  ChatDetailViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    viewModel.scrollController.removeListener(_onScroll);
    _showJump.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!viewModel.scrollController.hasClients) return;
    final pos = viewModel.scrollController.position;
    final distance = pos.maxScrollExtent - pos.pixels;
    final shouldShow = distance > 320;
    if (_showJump.value != shouldShow) _showJump.value = shouldShow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatHudStyle.space,
      body: ChatHudBackground(
        child: Column(
          children: [
            ChatAppBarWidget(
              title: viewModel.receiverName,
              subtitle: viewModel.receiverEmail ?? 'ONLINE',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Padding(
                padding: AppEdgeInsets.symmetric(horizontal: 16),
                child: RefreshIndicator(
                  color: ChatHudStyle.cyan,
                  backgroundColor: ChatHudStyle.space,
                  onRefresh: viewModel.refresh,
                  child: _MessagesList(
                    viewModel: viewModel,
                    onMessageLongPress: _onMessageLongPress,
                  ),
                ),
              ),
            ),
            if (viewModel.errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ChatErrorBannerWidget(
                  message: viewModel.errorMessage!,
                  onRetry: viewModel.loadMessages,
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: viewModel.messageController,
                        builder: (context, value, _) {
                          final show = value.text.trim().isNotEmpty;
                          if (!show) return const SizedBox.shrink();
                          return const ChatTypingIndicatorWidget(label: 'COMPOSING');
                        },
                      ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _showJump,
                    builder: (context, show, _) {
                      return ChatJumpToBottomWidget(
                        show: show,
                        onTap: () => viewModel.scrollToBottom(animated: true),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (_replySnippet != null)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
                child: ChatReplyPreviewWidget(
                  title: _isReplyToMe ? 'Reply to OUT' : 'Reply to IN',
                  snippet: _replySnippet!,
                  onClear: () => setState(() => _replySnippet = null),
                ),
              ),
            ChatComposerWidget(
              controller: viewModel.messageController,
              isSending: viewModel.isLoading,
              onSend: () async {
                if (_replySnippet != null &&
                    viewModel.messageController.text.trim().isNotEmpty) {
                  final prefix = _isReplyToMe ? '↩(OUT) ' : '↩(IN) ';
                  viewModel.messageController.text =
                      '$prefix${_replySnippet!}\n— ${viewModel.messageController.text.trim()}';
                }

                final ok = await viewModel.sendMessage();
                if (ok) {
                  setState(() => _replySnippet = null);
                  viewModel.scrollToBottom(animated: true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onMessageLongPress(MessageResponse m) async {
    final text = (m.lastMessage ?? '').trim();
    if (text.isEmpty) return;

    final isMe = viewModel.isMyMessage(m);
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: GlassPanel(
              padding: EdgeInsets.all(14.w),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: ChatHudStyle.glowCyan,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MESSAGE',
                    style: ChatHudStyle.label(11.sp, color: ChatHudStyle.dim),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: ChatHudStyle.body(13.sp, color: ChatHudStyle.text),
                  ),
                  SizedBox(height: 12.h),
                  Divider(height: 1, color: ChatHudStyle.cyan.withOpacity(0.25)),
                  SizedBox(height: 12.h),
                  _actionTile(context, 'copy', Icons.copy, 'Kopyala'),
                  SizedBox(height: 10.h),
                  _actionTile(
                    context,
                    'reply',
                    Icons.reply,
                    isMe ? 'Yanıtla (OUT)' : 'Yanıtla (IN)',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    if (action == 'copy') {
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kopyalandı')),
        );
      }
      return;
    }
    if (action == 'reply') {
      setState(() {
        _replySnippet = text.length > 90 ? '${text.substring(0, 90)}…' : text;
        _isReplyToMe = isMe;
      });
    }
  }

  Widget _actionTile(
    BuildContext context,
    String value,
    IconData icon,
    String label,
  ) {
    return InkWell(
      onTap: () => Navigator.pop(context, value),
      child: GlassPanel(
        borderRadius: BorderRadius.circular(14.r),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: ChatHudStyle.cyan),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(label, style: ChatHudStyle.body(13.sp)),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.sp, color: ChatHudStyle.dim),
          ],
        ),
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  final ChatDetailViewModel viewModel;
  final Future<void> Function(MessageResponse message) onMessageLongPress;

  const _MessagesList({
    required this.viewModel,
    required this.onMessageLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final messages = viewModel.messages;

    if (messages.isEmpty && !viewModel.isLoading) {
      return const ChatEmptyStateWidget();
    }

    return ListView.builder(
      controller: viewModel.scrollController,
      padding: EdgeInsets.only(top: 20.h, bottom: 40.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final m = messages[index];
        final isMe = viewModel.isMyMessage(m);
        final isPending = m.id?.startsWith('temp_') ?? false;
        final dt = m.createdAt ?? DateTime.now();

        final widgets = <Widget>[];

        final showDate = index == 0 ||
            (m.createdAt?.day != messages[index - 1].createdAt?.day);

        if (showDate) {
          widgets.add(ChatDaySeparatorWidget(date: m.createdAt));
        }

        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: GestureDetector(
              onLongPress: () => onMessageLongPress(m),
              child: ChatMessageBubbleWidget(
                key: ValueKey('msg-${m.id ?? widgets.length}'),
                isMe: isMe,
                text: (m.lastMessage ?? '').trim(),
                time: dt,
                isRead: m.isRead ?? false,
                isPending: isPending,
              ),
            ),
          ),
        );

        return Column(children: widgets);
      },
    );
  }
}
