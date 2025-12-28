import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/dtos/book_dto.dart';
import '../constants/exchange_style.dart';

/// BookMiniCardWidget - Horizontal scroll listede gösterilen küçük kitap kartı
/// 
/// Quantum Exchange tasarım dilini takip eder
/// - Kompakt görünüm
/// - Accent color ile seçim göstergesi
/// - Hover/tap efekti
class BookMiniCardWidget extends StatelessWidget {
  final BookResponse book;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback? onTap;

  const BookMiniCardWidget({
    super.key,
    required this.book,
    this.isSelected = false,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: ExchangeStyle.fast,
        curve: Curves.easeOutCubic,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected 
                ? accentColor 
                : accentColor.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11.r),
          child: Stack(
            children: [
              // Kitap görseli
              Positioned.fill(
                child: _buildBookImage(),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        ExchangeStyle.void_.withValues(alpha: 0.7),
                        ExchangeStyle.void_.withValues(alpha: 0.95),
                      ],
                      stops: const [0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Kitap bilgileri
              Positioned(
                left: 8.w,
                right: 8.w,
                bottom: 8.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      book.name ?? 'İsimsiz',
                      style: ExchangeStyle.bookTitle(fontSize: 10.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      book.writer ?? 'Bilinmeyen',
                      style: ExchangeStyle.bookAuthor(fontSize: 8.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Seçim göstergesi
              if (isSelected)
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check,
                      size: 12.sp,
                      color: ExchangeStyle.void_,
                    ),
                  ),
                ),

              // Tür etiketi
              if (book.type != null && !isSelected)
                Positioned(
                  top: 6.h,
                  left: 6.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: ExchangeStyle.void_.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      book.type!,
                      style: ExchangeStyle.label(
                        fontSize: 7.sp,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookImage() {
    if (book.imageUrl != null && book.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: book.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
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
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 28.sp,
          color: accentColor.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
