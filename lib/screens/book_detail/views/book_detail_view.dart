import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/constants/app_size.dart';
import '../../../base/constants/app_edge_insets.dart';
import '../../../base/constants/app_texts.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../common_widgets/cached_network_image_widget.dart';
import '../../../common_widgets/error_state_widget.dart';
import '../../../common_widgets/loading_widget.dart';
import '../../../domain/dtos/book_dto.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/book_detail_view_model.dart';

/// Book Detail View - Editorial Design
class BookDetailView extends StatelessWidget {
  final BookDetailViewModel viewModel;

  const BookDetailView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = viewModel.book;

    if (book == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: viewModel.errorMessage != null
            ? ErrorStateWidget.generic(
                title: 'Error',
                message: viewModel.errorMessage!,
                onRetry: () => viewModel.loadBookDetail(),
              )
            : LoadingWidget(
                size: 40.h,
                message: 'Loading details...',
              ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // 1. Immersive Header
          SliverAppBar(
            expandedHeight: 400.h,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.backgroundLight,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    viewModel.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: viewModel.isFavorite ? AppColors.errorColor : AppColors.textPrimary,
                  ),
                ),
                onPressed: () => _handleToggleFavorite(context),
              ),
              SizedBox(width: 8.w),
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.share_outlined, color: AppColors.textPrimary),
                ),
                onPressed: () => _handleShare(context, book),
              ),
              SizedBox(width: 16.w),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  book.imageUrl != null && book.imageUrl!.isNotEmpty
                      ? CachedNetworkImageWidget(
                          imageUrl: book.imageUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholderIcon: Icons.book,
                        )
                      : _buildPlaceholderImage(),
                  // Gradient Overlay for Text Readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.backgroundLight.withOpacity(0.2),
                            AppColors.backgroundLight,
                          ],
                          stops: const [0.6, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Editorial Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Author
                  Text(
                    book.name ?? 'Untitled',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 32.sp,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    book.writer ?? 'Unknown Author',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontFamily: 'Sans', // Contrast font
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Metadata Chips
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      if (book.language != null)
                        _buildChip(context, book.language!.toUpperCase()),
                      if (book.type != null)
                        _buildChip(context, book.type!, isPrimary: true),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // Description
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    book.description ?? 'No description available.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: AppColors.textPrimary.withOpacity(0.8),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Owner Profile Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            (viewModel.ownerName?.isNotEmpty == true
                                    ? viewModel.ownerName![0]
                                    : 'U')
                                .toUpperCase(),
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTexts.owner,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp,
                              ),
                            ),
                            Text(
                              viewModel.ownerName ?? 'Unknown User',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100.h), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Action Bar
      bottomSheet: Container(
        color: AppColors.backgroundLight,
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        child: viewModel.isMyBook
            ? Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      textTitle: 'Edit',
                      onTap: () => _handleEditBook(context),
                      isOutlined: true,
                      icon: Icon(Icons.edit_outlined, size: 20.sp, color: AppColors.primary),
                      color: AppColors.primary,
                      textColor: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ButtonWidget(
                      textTitle: 'Delete',
                      onTap: () => _handleDeleteBook(context),
                      color: AppColors.errorColor,
                      icon: Icon(Icons.delete_outline, size: 20.sp, color: AppColors.textWhite),
                    ),
                  ),
                ],
              )
            : ButtonWidget(
                textTitle: AppTexts.sendMessage,
                onTap: () => _handleSendMessage(context),
                icon: Icon(Icons.mail_outline, color: AppColors.textWhite),
              ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, {bool isPrimary = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
        border: Border.all(
          color: isPrimary ? AppColors.accent : AppColors.divider,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary ? AppColors.accent : AppColors.textSecondary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.greyLight,
      child: Center(
        child: Icon(
          Icons.auto_stories,
          size: 80.sp,
          color: AppColors.grey,
        ),
      ),
    );
  }

  // Handlers (kept same logic, updated UI feedbacks)
  void _handleSendMessage(BuildContext context) {
    if (viewModel.ownerId != null) {
      NavigationUtil.navigateToChatDetail(
        context,
        receiverId: viewModel.ownerId!,
        receiverName: viewModel.ownerName,
      );
    }
  }

  void _handleShare(BuildContext context, BookResponse book) {
    Share.share(
      'Check out "${book.name}" by ${book.writer} on KitApp!',
      subject: book.name,
    );
  }

  Future<void> _handleToggleFavorite(BuildContext context) async {
    await viewModel.toggleFavorite();
    // Feedback can be handled by ViewModel state or simple snackbar
  }

  Future<void> _handleEditBook(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit feature coming soon')),
    );
  }

  Future<void> _handleDeleteBook(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await viewModel.deleteBook();
      if (success && context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
