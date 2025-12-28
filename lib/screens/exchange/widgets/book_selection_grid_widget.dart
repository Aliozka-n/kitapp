import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/dtos/book_dto.dart';
import '../constants/exchange_style.dart';

/// Book Selection Grid Widget - Kullanıcının kitaplarından seçim yapması için grid
class BookSelectionGridWidget extends StatelessWidget {
  final List<BookResponse> books;
  final BookResponse? selectedBook;
  final Function(BookResponse) onBookSelected;

  const BookSelectionGridWidget({
    super.key,
    required this.books,
    this.selectedBook,
    required this.onBookSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.65,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        final isSelected = selectedBook?.id == book.id;
        return _BookGridItem(
          book: book,
          isSelected: isSelected,
          onTap: () => onBookSelected(book),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return ExchangeGlassPanel(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 64.sp,
            color: ExchangeStyle.dim,
          ),
          SizedBox(height: 16.h),
          Text(
            'Takas için kitabınız yok',
            style: ExchangeStyle.title(color: ExchangeStyle.dim),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Takas yapabilmek için önce kitap eklemelisiniz',
            style: ExchangeStyle.body(color: ExchangeStyle.dim),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BookGridItem extends StatelessWidget {
  final BookResponse book;
  final bool isSelected;
  final VoidCallback onTap;

  const _BookGridItem({
    required this.book,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: ExchangeStyle.fast,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? ExchangeStyle.quantum
                : ExchangeStyle.quantum.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? ExchangeStyle.quantumGlow : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Kitap resmi
              if (book.imageUrl != null && book.imageUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: book.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(),
                  errorWidget: (context, url, error) => _buildPlaceholder(),
                )
              else
                _buildPlaceholder(),

              // Karartma gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      ExchangeStyle.void_.withOpacity(0.9),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),

              // Seçim overlay
              if (isSelected)
                Container(
                  color: ExchangeStyle.quantum.withOpacity(0.2),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: ExchangeStyle.quantum,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: ExchangeStyle.void_,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),

              // Kitap bilgisi
              Positioned(
                left: 6.w,
                right: 6.w,
                bottom: 6.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      book.name ?? 'İsimsiz',
                      style: ExchangeStyle.label(
                        fontSize: 11.sp,
                        color: ExchangeStyle.bright,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      book.writer ?? 'Bilinmeyen',
                      style: ExchangeStyle.label(
                        fontSize: 9.sp,
                        color: ExchangeStyle.dim,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: ExchangeStyle.nebula,
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 32.sp,
          color: ExchangeStyle.dim,
        ),
      ),
    );
  }
}
