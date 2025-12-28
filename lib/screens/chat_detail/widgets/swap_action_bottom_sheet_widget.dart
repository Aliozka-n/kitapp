import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/dtos/swap_dto.dart';
import '../constants/chat_style_hud.dart';

/// Swap Action Bottom Sheet Widget - Takas kabul/red ekranı
/// 
/// Futuristik tasarımla takas detaylarını gösterir ve aksiyon alınmasını sağlar
class SwapActionBottomSheetWidget extends StatelessWidget {
  final SwapResponse swap;
  final bool isMyProposal;
  final Future<void> Function()? onAccept;
  final Future<void> Function()? onReject;

  const SwapActionBottomSheetWidget({
    super.key,
    required this.swap,
    required this.isMyProposal,
    this.onAccept,
    this.onReject,
  });

  static Future<void> show(
    BuildContext context, {
    required SwapResponse swap,
    required bool isMyProposal,
    Future<void> Function()? onAccept,
    Future<void> Function()? onReject,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SwapActionBottomSheetWidget(
        swap: swap,
        isMyProposal: isMyProposal,
        onAccept: onAccept,
        onReject: onReject,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _SwapSheetColors.surface,
                _SwapSheetColors.surface.withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(
              color: _SwapSheetColors.cyan.withOpacity(0.2),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  _buildHandle(),
                  SizedBox(height: 20.h),

                  // Başlık
                  _buildHeader(),
                  SizedBox(height: 24.h),

                  // Kitap karşılaştırması
                  _buildBookComparison(),
                  SizedBox(height: 24.h),

                  // Mesaj (varsa)
                  if (swap.message != null && swap.message!.isNotEmpty)
                    _buildMessage(),

                  // Aksiyonlar
                  if (!isMyProposal && swap.canAccept)
                    _buildActions(context),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: _SwapSheetColors.dim,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // İkon
        Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _SwapSheetColors.cyan,
                _SwapSheetColors.amber,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _SwapSheetColors.cyan.withOpacity(0.3),
                blurRadius: 16,
              ),
            ],
          ),
          child: Icon(
            Icons.swap_horiz_rounded,
            size: 28.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16.h),

        // Başlık
        Text(
          isMyProposal ? 'GÖNDERDİĞİNİZ TAKAS TEKLİFİ' : 'GELEN TAKAS TEKLİFİ',
          style: ChatHudStyle.label(11.sp, color: _SwapSheetColors.cyan),
        ),
        SizedBox(height: 6.h),
        Text(
          'Kitap Takası Detayı',
          style: ChatHudStyle.body(20.sp, color: _SwapSheetColors.bright),
        ),
      ],
    );
  }

  Widget _buildBookComparison() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _SwapSheetColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _SwapSheetColors.cyan.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Teklif edilen kitap
          Expanded(
            child: _buildBookCard(
              title: 'TEKLİF EDİLEN',
              book: swap.offeredBook,
              color: _SwapSheetColors.cyan,
            ),
          ),

          // Swap animasyonu
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _SwapSheetColors.cyan.withOpacity(0.2),
                        _SwapSheetColors.amber.withOpacity(0.2),
                      ],
                    ),
                    border: Border.all(
                      color: _SwapSheetColors.dim.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.compare_arrows_rounded,
                    size: 22.sp,
                    color: _SwapSheetColors.text,
                  ),
                ),
              ],
            ),
          ),

          // İstenen kitap
          Expanded(
            child: _buildBookCard(
              title: 'İSTENEN',
              book: swap.requestedBook,
              color: _SwapSheetColors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard({
    required String title,
    required dynamic book,
    required Color color,
  }) {
    final bookName = book?.name ?? 'Bilinmeyen';
    final bookWriter = book?.writer ?? 'Bilinmeyen Yazar';
    final bookImage = book?.imageUrl;

    return Column(
      children: [
        // Label
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
          ),
          child: Text(
            title,
            style: ChatHudStyle.label(9.sp, color: color),
          ),
        ),
        SizedBox(height: 12.h),

        // Kitap görseli
        Container(
          width: 90.w,
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: color.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 12,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9.r),
            child: bookImage != null && bookImage.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: bookImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildPlaceholder(color),
                    errorWidget: (context, url, error) =>
                        _buildPlaceholder(color),
                  )
                : _buildPlaceholder(color),
          ),
        ),
        SizedBox(height: 10.h),

        // Kitap adı
        Text(
          bookName,
          style: ChatHudStyle.body(13.sp, color: _SwapSheetColors.bright),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),

        // Yazar
        Text(
          bookWriter,
          style: ChatHudStyle.label(10.sp, color: _SwapSheetColors.dim),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPlaceholder(Color color) {
    return Container(
      color: _SwapSheetColors.cardBg,
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 36.sp,
          color: color.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: _SwapSheetColors.cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _SwapSheetColors.dim.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  size: 16.sp,
                  color: _SwapSheetColors.dim,
                ),
                SizedBox(width: 6.w),
                Text(
                  'MESAJ',
                  style: ChatHudStyle.label(10.sp, color: _SwapSheetColors.dim),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              swap.message!,
              style: ChatHudStyle.body(13.sp, color: _SwapSheetColors.text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          // Reddet butonu
          Expanded(
            child: _ActionButton(
              label: 'REDDET',
              icon: Icons.close_rounded,
              color: _SwapSheetColors.error,
              onTap: () async {
                if (onReject != null) {
                  await onReject!();
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          SizedBox(width: 12.w),

          // Kabul et butonu
          Expanded(
            flex: 2,
            child: _ActionButton(
              label: 'KABUL ET',
              icon: Icons.check_rounded,
              color: _SwapSheetColors.success,
              isPrimary: true,
              onTap: () async {
                if (onAccept != null) {
                  await onAccept!();
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isPrimary;
  final Future<void> Function()? onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);
              try {
                await widget.onTap?.call();
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: widget.isPrimary
              ? widget.color
              : widget.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: widget.color.withOpacity(widget.isPrimary ? 1 : 0.4),
            width: widget.isPrimary ? 0 : 1,
          ),
          boxShadow: widget.isPrimary
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: _isLoading
            ? Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isPrimary ? Colors.white : widget.color,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 20.sp,
                    color: widget.isPrimary ? Colors.white : widget.color,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    widget.label,
                    style: ChatHudStyle.label(
                      13.sp,
                      color: widget.isPrimary ? Colors.white : widget.color,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Swap Sheet Colors
class _SwapSheetColors {
  static const Color surface = Color(0xFF0E1218);
  static const Color cardBg = Color(0xFF1A1F2E);
  static const Color cyan = Color(0xFF00D4FF);
  static const Color amber = Color(0xFFFFB400);
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color dim = Color(0xFF4A5568);
  static const Color text = Color(0xFFE2E8F0);
  static const Color bright = Color(0xFFF7FAFC);
}
