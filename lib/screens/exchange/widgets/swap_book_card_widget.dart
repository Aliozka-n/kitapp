import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/dtos/book_dto.dart';
import '../constants/exchange_style.dart';

/// Swap Book Card Widget - Takas edilecek kitap kartı
/// 
/// İki farklı mod:
/// - offered: Kullanıcının teklif ettiği kitap (cyan tema)
/// - requested: İstenen kitap (amber tema)
class SwapBookCardWidget extends StatelessWidget {
  final BookResponse book;
  final bool isOffered;
  final bool isSelected;
  final VoidCallback? onTap;

  const SwapBookCardWidget({
    super.key,
    required this.book,
    this.isOffered = true,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isOffered ? ExchangeStyle.quantum : ExchangeStyle.amber;
    final gradient = isOffered
        ? ExchangeStyle.offeredCardGradient
        : ExchangeStyle.requestedCardGradient;
    final glow = isOffered ? ExchangeStyle.quantumGlow : ExchangeStyle.amberGlow;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: ExchangeStyle.normal,
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: ExchangeStyle.cardRadius,
          border: Border.all(
            color: isSelected ? accentColor : accentColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? glow : null,
        ),
        child: ClipRRect(
          borderRadius: ExchangeStyle.cardRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kitap resmi
              _buildBookImage(accentColor),
              
              // Kitap bilgileri
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Label
                    _buildLabel(accentColor),
                    SizedBox(height: 6.h),
                    
                    // Kitap adı
                    Text(
                      book.name ?? 'İsimsiz Kitap',
                      style: ExchangeStyle.bookTitle(fontSize: 13.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    
                    // Yazar
                    Text(
                      book.writer ?? 'Bilinmeyen Yazar',
                      style: ExchangeStyle.bookAuthor(fontSize: 10.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Tür badge
                    if (book.type != null) ...[
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: ExchangeStyle.chipRadius,
                          border: Border.all(
                            color: accentColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          book.type!,
                          style: ExchangeStyle.label(
                            fontSize: 9.sp,
                            color: accentColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookImage(Color accentColor) {
    final hasImage = book.imageUrl != null && book.imageUrl!.isNotEmpty;
    
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Stack(
        children: [
          // Kitap resmi veya placeholder
          Positioned.fill(
            child: hasImage
                ? CachedNetworkImage(
                    imageUrl: book.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildPlaceholder(accentColor),
                    errorWidget: (context, url, error) => _buildPlaceholder(accentColor),
                  )
                : _buildPlaceholder(accentColor),
          ),

          // Seçili overlay - sadece görsel varsa veya seçiliyse
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      accentColor.withOpacity(0.15),
                      accentColor.withOpacity(0.35),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: ExchangeStyle.void_,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ),

          // Corner badge - üst sol köşede
          Positioned(
            top: 6.h,
            left: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 3.h,
              ),
              decoration: BoxDecoration(
                color: ExchangeStyle.void_.withOpacity(0.85),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: accentColor.withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Text(
                isOffered ? 'TEKLİF' : 'İSTENEN',
                style: ExchangeStyle.label(
                  fontSize: 8.sp,
                  color: accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(Color accentColor) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            isOffered ? 'SİZİN KİTABINIZ' : 'İSTENEN KİTAP',
            style: ExchangeStyle.label(
              fontSize: 9.sp,
              color: accentColor,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(Color accentColor) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ExchangeStyle.nebula,
            ExchangeStyle.stardust,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories_rounded,
            size: 36.sp,
            color: accentColor.withOpacity(0.4),
          ),
          SizedBox(height: 6.h),
          Text(
            'Görsel Yok',
            style: ExchangeStyle.label(
              fontSize: 10.sp,
              color: ExchangeStyle.dim,
            ),
          ),
        ],
      ),
    );
  }
}
