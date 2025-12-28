import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/dtos/swap_dto.dart';
import '../../../domain/enums/swap_status.dart';
import '../constants/chat_style_hud.dart';

/// Swap Proposal Card Widget - Chat içinde takas teklifi kartı
/// 
/// Takas tekliflerini görsel olarak çekici bir şekilde gösterir
class SwapProposalCardWidget extends StatelessWidget {
  final SwapResponse swap;
  final bool isMyProposal;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onWithdraw; // Geri çekme callback
  final VoidCallback? onViewDetails;

  const SwapProposalCardWidget({
    super.key,
    required this.swap,
    required this.isMyProposal,
    this.onAccept,
    this.onReject,
    this.onWithdraw,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        constraints: BoxConstraints(maxWidth: 280.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _SwapCardColors.cardBg,
              _SwapCardColors.cardBg.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _getStatusColor().withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _getStatusColor().withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(),

              // Kitap görselleri
              _buildBooksSection(),

              // Durum ve aksiyonlar
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor().withOpacity(0.2),
            _getStatusColor().withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: _getStatusColor().withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // İkon
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.swap_horiz_rounded,
              size: 18.sp,
              color: _getStatusColor(),
            ),
          ),
          SizedBox(width: 10.w),

          // Başlık
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMyProposal ? 'GÖNDERDİĞİNİZ TEKLİF' : 'GELEN TEKLİF',
                  style: ChatHudStyle.label(10.sp, color: _getStatusColor()),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Kitap Takası',
                  style: ChatHudStyle.body(13.sp, color: ChatHudStyle.text),
                ),
              ],
            ),
          ),

          // Durum badge
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildBooksSection() {
    return Padding(
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          // Teklif edilen kitap
          Expanded(
            child: _buildBookPreview(
              book: swap.offeredBook,
              label: 'TEKLİF',
              color: _SwapCardColors.cyan,
            ),
          ),

          // Swap oku
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.compare_arrows_rounded,
                  size: 24.sp,
                  color: ChatHudStyle.dim,
                ),
                SizedBox(height: 4.h),
                Text(
                  '⇄',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ChatHudStyle.dim,
                  ),
                ),
              ],
            ),
          ),

          // İstenen kitap
          Expanded(
            child: _buildBookPreview(
              book: swap.requestedBook,
              label: 'İSTENEN',
              color: _SwapCardColors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookPreview({
    required dynamic book,
    required String label,
    required Color color,
  }) {
    final bookName = book?.name ?? 'Bilinmeyen';
    final bookImage = book?.imageUrl;

    return Column(
      children: [
        // Label
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            label,
            style: ChatHudStyle.label(8.sp, color: color),
          ),
        ),
        SizedBox(height: 8.h),

        // Kitap görseli
        Container(
          width: 70.w,
          height: 95.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7.r),
            child: bookImage != null && bookImage.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: bookImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildBookPlaceholder(color),
                    errorWidget: (context, url, error) =>
                        _buildBookPlaceholder(color),
                  )
                : _buildBookPlaceholder(color),
          ),
        ),
        SizedBox(height: 6.h),

        // Kitap adı
        SizedBox(
          width: 80.w,
          child: Text(
            bookName,
            style: ChatHudStyle.label(10.sp, color: ChatHudStyle.text),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBookPlaceholder(Color color) {
    return Container(
      color: _SwapCardColors.cardBg,
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 28.sp,
          color: color.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    // Beklemede ve gelen teklif ise aksiyon butonları göster
    final showReceiverActions = swap.status == SwapStatus.pending && !isMyProposal;
    // Beklemede ve gönderen ise geri çekme butonu göster
    final showWithdrawAction = swap.status == SwapStatus.pending && isMyProposal;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: _SwapCardColors.cardBg.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: ChatHudStyle.dim.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: showReceiverActions
          ? _buildActionButtons()
          : showWithdrawAction
              ? _buildWithdrawButton()
              : _buildStatusInfo(),
    );
  }

  Widget _buildWithdrawButton() {
    return _SwapActionButton(
      label: 'TEKLİFİ GERİ ÇEK',
      icon: Icons.undo_rounded,
      color: _SwapCardColors.pending,
      onTap: onWithdraw,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Reddet butonu
        Expanded(
          child: _SwapActionButton(
            label: 'REDDET',
            icon: Icons.close_rounded,
            color: _SwapCardColors.error,
            onTap: onReject,
          ),
        ),
        SizedBox(width: 10.w),

        // Kabul et butonu
        Expanded(
          child: _SwapActionButton(
            label: 'KABUL ET',
            icon: Icons.check_rounded,
            color: _SwapCardColors.success,
            isPrimary: true,
            onTap: onAccept,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusInfo() {
    String statusText;
    IconData statusIcon;

    switch (swap.status) {
      case SwapStatus.pending:
        statusText = isMyProposal
            ? 'Yanıt bekleniyor...'
            : 'Beklemede';
        statusIcon = Icons.hourglass_empty_rounded;
        break;
      case SwapStatus.accepted:
        statusText = 'Kabul edildi';
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      case SwapStatus.rejected:
        statusText = 'Reddedildi';
        statusIcon = Icons.cancel_outlined;
        break;
      case SwapStatus.cancelled:
        statusText = 'İptal edildi';
        statusIcon = Icons.block_rounded;
        break;
      case SwapStatus.completed:
        statusText = 'Tamamlandı';
        statusIcon = Icons.celebration_rounded;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          statusIcon,
          size: 16.sp,
          color: _getStatusColor(),
        ),
        SizedBox(width: 8.w),
        Text(
          statusText,
          style: ChatHudStyle.body(12.sp, color: _getStatusColor()),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.15),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
        ),
      ),
      child: Text(
        swap.status.icon,
        style: TextStyle(fontSize: 12.sp),
      ),
    );
  }

  Color _getStatusColor() {
    switch (swap.status) {
      case SwapStatus.pending:
        return _SwapCardColors.pending;
      case SwapStatus.accepted:
        return _SwapCardColors.success;
      case SwapStatus.rejected:
        return _SwapCardColors.error;
      case SwapStatus.cancelled:
        return _SwapCardColors.dim;
      case SwapStatus.completed:
        return _SwapCardColors.success;
    }
  }
}

/// Swap Action Button
class _SwapActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isPrimary;
  final VoidCallback? onTap;

  const _SwapActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final effectiveColor = isDisabled ? _SwapCardColors.dim : color;
    
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isPrimary && !isDisabled 
                ? effectiveColor 
                : effectiveColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: effectiveColor.withOpacity(isPrimary && !isDisabled ? 1 : 0.4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isDisabled)
                SizedBox(
                  width: 14.sp,
                  height: 14.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      isPrimary ? Colors.white.withOpacity(0.7) : effectiveColor,
                    ),
                  ),
                )
              else
                Icon(
                  icon,
                  size: 16.sp,
                  color: isPrimary ? Colors.white : effectiveColor,
                ),
              SizedBox(width: 6.w),
              Text(
                isDisabled ? 'İŞLENİYOR...' : label,
                style: ChatHudStyle.label(
                  11.sp,
                  color: isPrimary && !isDisabled ? Colors.white : effectiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Swap Card Colors
class _SwapCardColors {
  static const Color cardBg = Color(0xFF1A1F2E);
  static const Color cyan = Color(0xFF00D4FF);
  static const Color amber = Color(0xFFFFB400);
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color pending = Color(0xFFFF9100);
  static const Color dim = Color(0xFF4A5568);
}
