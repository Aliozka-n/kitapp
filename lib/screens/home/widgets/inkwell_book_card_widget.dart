import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../base/constants/app_constants.dart';
import '../../../domain/dtos/book_dto.dart';

enum InkwellBookCardVariant { rail, grid }

class InkwellBookCardWidget extends StatelessWidget {
  final BookResponse book;
  final VoidCallback onTap;
  final InkwellBookCardVariant variant;

  const InkwellBookCardWidget({
    super.key,
    required this.book,
    required this.onTap,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite ? constraints.maxWidth : 160.w;
        final titleSize =
            variant == InkwellBookCardVariant.grid ? 13.sp : 14.sp;
        final metaSize = 12.sp;

        // Grid'de parent genelde "tight height" verir; 1-2px sapma bile overflow yapar.
        // Bu yüzden cover yüksekliğini mevcut maxHeight'e göre hesaplayıp güvenli hale getiriyoruz.
        final hasMaxH = constraints.maxHeight.isFinite && constraints.maxHeight > 0;
        final titleH = titleSize * 1.15;
        final metaH = metaSize * 1.15;
        final gaps = 10.h + 4.h; // cover->title + title->meta
        final textBlockH = gaps + titleH + metaH;

        // 4:5 cover ratio "hedef", ama maxHeight darsa cover otomatik kısalır.
        final targetCoverH = w * 1.25;
        final coverH = hasMaxH
            ? (constraints.maxHeight - textBlockH).clamp(0.0, targetCoverH)
            : targetCoverH;

        return GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover
              SizedBox(
                height: coverH,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    border: Border.all(color: AppColors.primary, width: 2),
                    boxShadow: AppShadows.sharp,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if ((book.imageUrl ?? '').trim().isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: book.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const _CoverFallbackIcon(),
                        )
                      else
                        const _CoverFallbackIcon(),

                      // Editorial stamp
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: _Stamp(
                          text: (book.type ?? 'KİTAP').toUpperCase(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                (book.name?.trim().isNotEmpty ?? false)
                    ? book.name!.toUpperCase()
                    : 'İSİMSİZ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.syne(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                (book.writer?.trim().isNotEmpty ?? false)
                    ? book.writer!
                    : 'Yazar Belirtilmemiş',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.instrumentSans(
                  fontSize: metaSize,
                  color: AppColors.textSecondary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CoverFallbackIcon extends StatelessWidget {
  const _CoverFallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  final String text;

  const _Stamp({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.syne(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: AppColors.textWhite,
        ),
      ),
    );
  }
}


