import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/constants/app_size.dart';
import '../../../base/constants/app_edge_insets.dart';
import '../../../base/constants/home_constants.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../common_widgets/empty_state_widget.dart';
import '../../../common_widgets/error_state_widget.dart';
import '../../../common_widgets/book_card_shimmer.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/home_view_model.dart';
import '../widgets/book_card_widget.dart';

/// Home View - Editorial Layout
class HomeView extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => viewModel.loadBooks(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Editorial Header
              SliverPadding(
                padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 20.h),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Find your next favorite story.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Search & Filters (Pinned)
              SliverAppBar(
                backgroundColor: AppColors.backgroundLight,
                surfaceTintColor: AppColors.backgroundLight,
                floating: true,
                pinned: true,
                snap: false,
                toolbarHeight: 140.h, // Adjusted height for search + chips
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: TextFieldWidget(
                          textController: viewModel.searchController,
                          hintText: HomeConstants.searchPlaceholder,
                          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                          onChanged: (value) => viewModel.reloadState(),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        height: 40.h,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: HomeConstants.filters.length,
                          itemBuilder: (context, index) {
                            final filter = HomeConstants.filters[index];
                            final isSelected = viewModel.selectedFilter == filter;
                            
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: FilterChip(
                                label: Text(filter),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    viewModel.setFilter(filter);
                                  } else {
                                    viewModel.setFilter(HomeConstants.filters[0]);
                                  }
                                },
                                backgroundColor: Colors.transparent,
                                selectedColor: AppColors.primary,
                                checkmarkColor: AppColors.textWhite,
                                showCheckmark: false,
                                labelStyle: TextStyle(
                                  color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: isSelected ? AppColors.primary : AppColors.divider,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Content
              if (viewModel.isLoading && viewModel.books.isEmpty)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  sliver: _buildShimmerGrid(),
                )
              else if (viewModel.errorMessage != null)
                SliverFillRemaining(
                  child: ErrorStateWidget.generic(
                    title: 'Something went wrong',
                    message: viewModel.errorMessage!,
                    onRetry: () => viewModel.loadBooks(),
                  ),
                )
              else if (viewModel.books.isEmpty)
                 SliverFillRemaining(
                  child: EmptyStateWidget.noBooks(
                    onAction: () {
                      NavigationUtil.navigateToPage(
                        context,
                        NavigationUtil.addBookScreen,
                      );
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65, // Taller cards for books
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 24.h,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = viewModel.books[index];
                        return BookCardWidget(
                          book: book,
                          onTap: () {
                            NavigationUtil.navigateToPage(
                              context,
                              NavigationUtil.bookDetailScreen,
                              arguments: book.id,
                            );
                          },
                        );
                      },
                      childCount: viewModel.books.length,
                    ),
                  ),
                ),
                
               SliverToBoxAdapter(child: SizedBox(height: 80.h)), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 24.h,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => const BookCardShimmer(),
        childCount: 6,
      ),
    );
  }
}
