import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/constants/home_constants.dart';
import '../../../domain/dtos/book_dto.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/home_view_model.dart';
import '../widgets/inkwell_book_card_widget.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                _buildSearchBar(),
                SizedBox(height: 32.h),
                _buildSectionHeader("YENİ EKLENENLER", () {}),
                SizedBox(height: 16.h),
                _buildHorizontalBooks(viewModel.newlyListedBooks),
                SizedBox(height: 40.h),
                _buildSectionHeader("KEŞFET", () {}),
                _buildFilterChips(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
        _buildRecommendedGrid(context),
        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 80.h,
      backgroundColor: AppColors.backgroundLight,
      centerTitle: false,
      title: Text(
        "KİTAPP",
        style: GoogleFonts.syne(
          color: AppColors.textPrimary,
          fontSize: 28.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => NavigationUtil.navigateToProfile(context),
          icon: const Icon(Icons.person_outline),
        ),
        SizedBox(width: 16.w),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextFieldWidget(
      label: "ARAMA",
      hintText: "Kitap, yazar veya tür ara...",
      controller: viewModel.searchController,
      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.syne(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: AppColors.primary,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            "TÜMÜ",
            style: GoogleFonts.syne(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalBooks(List<BookResponse> books) {
    if (books.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 280.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        separatorBuilder: (context, index) => SizedBox(width: 20.w),
        itemBuilder: (context, index) => SizedBox(
          width: 160.w,
          child: InkwellBookCardWidget(
            book: books[index],
            variant: InkwellBookCardVariant.rail,
            onTap: () => NavigationUtil.navigateToBookDetail(
              context,
              books[index].id ?? "",
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: HomeConstants.filters.map((filter) {
          final isSelected = viewModel.selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: ChoiceChip(
              label: Text(filter.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) viewModel.setFilter(filter);
              },
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.backgroundWhite,
              labelStyle: GoogleFonts.syne(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.textWhite : AppColors.primary,
                letterSpacing: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(
                  color: AppColors.primary,
                  width: isSelected ? 0 : 1.5,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendedGrid(BuildContext context) {
    final books = viewModel.books;

    if (books.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              border: Border.all(color: AppColors.primary, width: 2),
              boxShadow: AppShadows.sharp,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HENÜZ KİTAP YOK',
                  style: GoogleFonts.syne(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Keşfetmeye başlamak için ilk kitabı ekle.',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Compute a safe aspect ratio so card content never overflows.
    final screenW = MediaQuery.sizeOf(context).width;
    final pad = 24.w * 2;
    final crossSpacing = 20.w;
    const crossAxisCount = 2;
    final tileW = (screenW - pad - crossSpacing) / crossAxisCount;
    final coverH = tileW * 1.25; // 4:5
    final textH = 10.h +
        14.sp +
        4.h +
        12.sp +
        6.h; // spacing + title + spacing + meta + slack
    final tileH = coverH + textH;
    final ratio = tileW / tileH;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 24.h,
          crossAxisSpacing: 20.w,
          childAspectRatio: ratio,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => InkwellBookCardWidget(
            book: books[index],
            variant: InkwellBookCardVariant.grid,
            onTap: () => NavigationUtil.navigateToBookDetail(
              context,
              books[index].id ?? "",
            ),
          ),
          childCount: books.length,
        ),
      ),
    );
  }
}
