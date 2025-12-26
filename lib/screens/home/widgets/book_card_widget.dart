import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base/constants/app_constants.dart';
import '../../../common_widgets/cached_network_image_widget.dart';
import '../../../domain/dtos/book_dto.dart';

/// Book Card Widget - Editorial Style
/// Focuses on the cover art with clean typography below.
class BookCardWidget extends StatelessWidget {
  final BookResponse book;
  final VoidCallback? onTap;

  const BookCardWidget({
    Key? key,
    required this.book,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image Container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.1),
                    blurRadius: 12.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: book.imageUrl != null && book.imageUrl!.isNotEmpty
                    ? CachedNetworkImageWidget(
                        imageUrl: book.imageUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholderIcon: Icons.book,
                      )
                    : _buildPlaceholder(),
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Book Info
          Text(
            book.name ?? 'Untitled',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              height: 1.2,
              fontFamily: 'Serif', // Fallback or if setup
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 4.h),
          
          Text(
            book.writer ?? 'Unknown Author',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 6.h),
          
          // Micro-details (Language / Type)
          if (book.language != null)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    book.language!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.greyLight,
      child: Center(
        child: Icon(
          Icons.auto_stories_outlined,
          size: 40.sp,
          color: AppColors.grey,
        ),
      ),
    );
  }
}
