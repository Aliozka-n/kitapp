import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/constants/app_size.dart';
import '../../../base/constants/app_edge_insets.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../common_widgets/empty_state_widget.dart';
import '../../../common_widgets/error_state_widget.dart';
import '../../../common_widgets/book_card_shimmer.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/search_view_model.dart';
import '../../home/widgets/book_card_widget.dart';

/// Search View - Arama ekranı UI
class SearchView extends StatelessWidget {
  final SearchViewModel viewModel;

  const SearchView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Kitap Ara'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(context),
            
            // Filter Chips
            _buildFilterChips(),
            
            // Search Results
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => viewModel.performSearch(),
                child: viewModel.isLoading && viewModel.searchResults.isEmpty
                    ? _buildShimmerList()
                    : _buildSearchResults(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: AppEdgeInsets.symmetric(
        horizontal: AppSizes.sizeLarge,
        vertical: AppSizes.sizeMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: AppShadows.small,
      ),
      child: TextFieldWidget(
        textController: viewModel.searchController,
        hintText: 'Kitap adı, yazar veya tür ara...',
        textIcon: Icons.search,
        onChanged: (value) {
          // ViewModel'deki listener otomatik tetiklenir
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Roman', 'Hikaye', 'Şiir', 'Bilim', 'Tarih'];
    final languages = ['Türkçe', 'İngilizce', 'Almanca', 'Fransızca'];

    return Container(
      padding: AppEdgeInsets.symmetric(
        horizontal: AppSizes.sizeLarge,
        vertical: AppSizes.sizeSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Filters
          if (filters.isNotEmpty) ...[
            Text(
              'Tür',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSizes.sizeSmall.h),
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = viewModel.selectedType == filter;
                  
                  return Padding(
                    padding: AppEdgeInsets.only(right: AppSizes.sizeSmall),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        viewModel.setTypeFilter(selected ? filter : null);
                      },
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: 13.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      padding: AppEdgeInsets.symmetric(
                        horizontal: AppSizes.sizeMedium,
                        vertical: AppSizes.sizeXSmall,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppSizes.sizeMedium.h),
          ],
          
          // Language Filters
          if (languages.isNotEmpty) ...[
            Text(
              'Dil',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSizes.sizeSmall.h),
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final language = languages[index];
                  final isSelected = viewModel.selectedLanguage == language;
                  
                  return Padding(
                    padding: AppEdgeInsets.only(right: AppSizes.sizeSmall),
                    child: FilterChip(
                      label: Text(language),
                      selected: isSelected,
                      onSelected: (selected) {
                        viewModel.setLanguageFilter(selected ? language : null);
                      },
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: 13.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      padding: AppEdgeInsets.symmetric(
                        horizontal: AppSizes.sizeMedium,
                        vertical: AppSizes.sizeXSmall,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return GridView.builder(
      padding: AppEdgeInsets.all(AppSizes.sizeLarge),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: AppSizes.sizeMedium.w,
        mainAxisSpacing: AppSizes.sizeMedium.h,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return BookCardShimmer();
      },
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    // Error State
    if (viewModel.errorMessage != null) {
      return ErrorStateWidget.generic(
        title: 'Arama Hatası',
        message: viewModel.errorMessage!,
        onRetry: () => viewModel.performSearch(),
      );
    }

    final results = viewModel.searchResults;

    // Empty State - Arama yapılmamış
    if (!viewModel.hasSearchQuery &&
        viewModel.selectedType == null &&
        viewModel.selectedLanguage == null) {
      return EmptyStateWidget.generic(
        icon: Icons.search_off,
        title: 'Arama Yapın',
        message: 'Kitap adı, yazar veya tür ile arama yapabilirsiniz',
      );
    }

    // Empty State - Sonuç bulunamadı
    if (results.isEmpty) {
      return EmptyStateWidget.generic(
        icon: Icons.book_outlined,
        title: 'Sonuç Bulunamadı',
        message: 'Arama kriterlerinize uygun kitap bulunamadı',
        onAction: () => viewModel.clearFilters(),
        actionText: 'Filtreleri Temizle',
      );
    }

    // Results Grid
    return GridView.builder(
      padding: AppEdgeInsets.all(AppSizes.sizeLarge),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: AppSizes.sizeMedium.w,
        mainAxisSpacing: AppSizes.sizeMedium.h,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
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
    );
  }
}

