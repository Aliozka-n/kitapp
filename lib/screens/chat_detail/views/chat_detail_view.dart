import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../../base/constants/app_edge_insets.dart';
import '../../../domain/dtos/message_dto.dart';
import '../../../domain/dtos/swap_dto.dart';
import '../../../domain/enums/swap_status.dart';
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
import '../widgets/swap_start_bottom_sheet_widget.dart';
import '../widgets/swap_proposal_card_widget.dart';

class ChatDetailView extends StatefulWidget {
  final ChatDetailViewModel viewModel;

  const ChatDetailView({
    super.key,
    required this.viewModel,
  });

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView>
    with WidgetsBindingObserver {
  final ValueNotifier<bool> _showJump = ValueNotifier<bool>(false);
  String? _replySnippet;
  bool _isReplyToMe = false;
  int _lastMessageCount = 0;
  bool _hasScrolledToBottom = false;

  ChatDetailViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);

    // ViewModel'deki değişiklikleri dinle
    viewModel.addListener(_onViewModelChanged);

    // Sayfa açıldığında mesajlar yüklendikten sonra en alta scroll et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndScrollToBottom();
    });
  }

  void _onViewModelChanged() {
    // Mesajlar yüklendiğinde veya değiştiğinde kontrol et
    if (viewModel.messages.length != _lastMessageCount) {
      _lastMessageCount = viewModel.messages.length;

      // İlk yükleme ise veya mesaj eklendi ise scroll et
      if (!_hasScrolledToBottom && viewModel.messages.isNotEmpty) {
        _checkAndScrollToBottom();
      }
    }
  }

  void _checkAndScrollToBottom() {
    if (!mounted || viewModel.messages.isEmpty) return;

    // Birkaç frame bekle ki ListView tam render olsun
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && viewModel.scrollController.hasClients) {
        viewModel.scrollToBottom(animated: false);
        _hasScrolledToBottom = true;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    viewModel.scrollController.removeListener(_onScroll);
    viewModel.removeListener(_onViewModelChanged);
    _showJump.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App ön plana geldiğinde mesajları yenile
    if (state == AppLifecycleState.resumed) {
      viewModel.refresh();
    }
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
              onSwapTap: () => _showSwapBottomSheet(context),
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
                    onAcceptSwap: _onAcceptSwap,
                    onRejectSwap: _onRejectSwap,
                    onWithdrawSwap: _onWithdrawSwap,
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
                          return const ChatTypingIndicatorWidget(
                              label: 'COMPOSING');
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
                  Divider(
                      height: 1, color: ChatHudStyle.cyan.withOpacity(0.25)),
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

  /// Takas bottom sheet'i göster
  void _showSwapBottomSheet(BuildContext context) {
    SwapStartBottomSheetWidget.show(
      context,
      receiverId: viewModel.receiverId,
      receiverName: viewModel.receiverName,
    );
  }

  /// Swap teklifini kabul et
  Future<void> _onAcceptSwap(String swapId) async {
    final success = await viewModel.acceptSwap(swapId);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Takas kabul edildi! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Swap teklifini reddet
  Future<void> _onRejectSwap(String swapId) async {
    final success = await viewModel.rejectSwap(swapId);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Takas reddedildi'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  /// Swap teklifini geri çek
  Future<void> _onWithdrawSwap(String swapId) async {
    final success = await viewModel.withdrawSwap(swapId);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Takas teklifi geri çekildi'),
          backgroundColor: Colors.grey,
        ),
      );
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
  final Future<void> Function(String swapId) onAcceptSwap;
  final Future<void> Function(String swapId) onRejectSwap;
  final Future<void> Function(String swapId) onWithdrawSwap;

  const _MessagesList({
    required this.viewModel,
    required this.onMessageLongPress,
    required this.onAcceptSwap,
    required this.onRejectSwap,
    required this.onWithdrawSwap,
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

        // Sadece swap_proposal tipi kartla gösterilmeli
        final isSwapProposal = m.messageType == 'swap_proposal';

        if (isSwapProposal && m.swapProposalId != null) {
          // Swap mesajı - özel kart göster
          widgets.add(
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: _SwapMessageCard(
                  key: ValueKey('swap-${m.swapProposalId}-${m.id}'),
                  viewModel: viewModel,
                  message: m,
                  isMe: isMe,
                  onAccept: () async => onAcceptSwap(m.swapProposalId!),
                  onReject: () async => onRejectSwap(m.swapProposalId!),
                  onWithdraw: () async => onWithdrawSwap(m.swapProposalId!),
                ),
              ),
            ),
          );
        } else {
          // Normal mesaj
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
        }

        return Column(children: widgets);
      },
    );
  }
}

/// Swap mesajı için özel kart
class _SwapMessageCard extends StatefulWidget {
  final ChatDetailViewModel viewModel;
  final MessageResponse message;
  final bool isMe;
  final Future<void> Function() onAccept;
  final Future<void> Function() onReject;
  final Future<void> Function() onWithdraw;

  const _SwapMessageCard({
    super.key,
    required this.viewModel,
    required this.message,
    required this.isMe,
    required this.onAccept,
    required this.onReject,
    required this.onWithdraw,
  });

  @override
  State<_SwapMessageCard> createState() => _SwapMessageCardState();
}

class _SwapMessageCardState extends State<_SwapMessageCard> {
  SwapResponse? _swap;
  bool _isLoading = true;
  bool _isProcessing = false; // İşlem yapılıyor mu

  @override
  void initState() {
    super.initState();
    // Her zaman forceRefresh ile yükle - cache'den eski veri gelmesin
    _loadSwapDetail();
  }

  Future<void> _loadSwapDetail() async {
    if (widget.message.swapProposalId == null) return;

    // Her zaman güncel veri al - cache kullanma
    final swap = await widget.viewModel.getSwapDetail(
      widget.message.swapProposalId!,
      forceRefresh: true,
    );
    if (mounted) {
      setState(() {
        _swap = swap;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAccept() async {
    if (_isProcessing || _swap == null) return;
    setState(() => _isProcessing = true);

    await widget.onAccept();

    // İşlem başarılı - local state'i hemen güncelle
    if (mounted && _swap != null) {
      setState(() {
        _swap = _swap!.copyWithStatus(SwapStatus.accepted);
        _isProcessing = false;
      });
    }
  }

  Future<void> _handleReject() async {
    if (_isProcessing || _swap == null) return;
    setState(() => _isProcessing = true);

    await widget.onReject();

    // İşlem başarılı - local state'i hemen güncelle
    if (mounted && _swap != null) {
      setState(() {
        _swap = _swap!.copyWithStatus(SwapStatus.rejected);
        _isProcessing = false;
      });
    }
  }

  Future<void> _handleWithdraw() async {
    if (_isProcessing || _swap == null) return;
    setState(() => _isProcessing = true);

    await widget.onWithdraw();

    // İşlem başarılı - local state'i hemen güncelle
    if (mounted && _swap != null) {
      setState(() {
        _swap = _swap!.copyWithStatus(SwapStatus.cancelled);
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingCard();
    }

    if (_swap == null) {
      return _buildErrorCard();
    }

    // Status pending değilse butonları tamamen kaldır
    final isPending = _swap!.status == SwapStatus.pending;
    final canShowActions = isPending && !_isProcessing;

    return SwapProposalCardWidget(
      swap: _swap!,
      isMyProposal: widget.isMe,
      onAccept: canShowActions && !widget.isMe ? _handleAccept : null,
      onReject: canShowActions && !widget.isMe ? _handleReject : null,
      onWithdraw: canShowActions && widget.isMe ? _handleWithdraw : null,
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: 200.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ChatHudStyle.space.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ChatHudStyle.cyan.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(ChatHudStyle.cyan),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'Takas yükleniyor...',
            style: ChatHudStyle.body(12.sp, color: ChatHudStyle.dim),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: 200.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ChatHudStyle.space.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 16.sp, color: Colors.red),
          SizedBox(width: 10.w),
          Text(
            'Takas yüklenemedi',
            style: ChatHudStyle.body(12.sp, color: ChatHudStyle.dim),
          ),
        ],
      ),
    );
  }
}
