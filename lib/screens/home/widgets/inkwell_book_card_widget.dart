import 'dart:ui';
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
  final VoidCallback? onLongPress;
  final InkwellBookCardVariant variant;

  const InkwellBookCardWidget({
    super.key,
    required this.book,
    required this.onTap,
    this.onLongPress,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite ? constraints.maxWidth : 160.w;
        final titleSize = variant == InkwellBookCardVariant.grid ? 14.sp : 15.sp;
        final metaSize = 12.sp;

        final hasMaxH = constraints.maxHeight.isFinite && constraints.maxHeight > 0;
        final titleH = titleSize * 1.3;
        final metaH = metaSize * 1.3;
        final gaps = 12.h + 4.h; 
        final textBlockH = gaps + titleH + metaH;

        final targetCoverH = variant == InkwellBookCardVariant.rail ? w * 1.4 : w * 1.35;
        final coverH = hasMaxH
            ? (constraints.maxHeight - textBlockH).clamp(0.0, targetCoverH)
            : targetCoverH;

        return GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover with futuristic styling
              Container(
                height: coverH,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.primaryLight,
                  boxShadow: AppShadows.card,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if ((book.imageUrl ?? '').trim().isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: book.imageUrl ?? "",
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

                      // Floating tag
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: _Tag(
                          text: (book.type ?? 'KİTAP'),
                        ),
                      ),
                      
                      // Bottom gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (book.name?.trim().isNotEmpty ?? false)
                          ? book.name ?? ""
                          : 'İsimsiz',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 0,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      (book.writer?.trim().isNotEmpty ?? false)
                          ? book.writer ?? ""
                          : 'Yazar Belirtilmemiş',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: metaSize,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.auto_stories_rounded, color: AppColors.accent, size: 32.sp),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.accentCyan,
            ),
          ),
        ),
      ),
    );
  }
}




