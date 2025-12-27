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
    final isSearching = viewModel.isSearchActive;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundCanvas,
            AppColors.primary,
          ],
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _buildSearchBar(),

                  // Arama aktif değilken: Yeni Eklenenler ve Keşfet göster
                  AnimatedCrossFade(
                    firstChild: _buildDiscoverySections(),
                    secondChild: _buildSearchResultsHeader(),
                    crossFadeState: isSearching
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                    sizeCurve: Curves.easeOutCubic,
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeIn,
                  ),
                ],
              ),
            ),
          ),
          _buildRecommendedGrid(context),
          SliverToBoxAdapter(child: SizedBox(height: 140.h)),
        ],
      ),
    );
  }

  /// Ana sayfa keşif bölümleri (Arama aktif değilken görünür)
  Widget _buildDiscoverySections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 36.h),
        _buildSectionHeader("YENİ EKLENENLER", () {}),
        SizedBox(height: 20.h),
        _buildHorizontalBooks(viewModel.newlyListedBooks),
        SizedBox(height: 44.h),
        _buildSectionHeader("KEŞFET", () {}),
        SizedBox(height: 16.h),
        _buildFilterChips(),
        SizedBox(height: 24.h),
      ],
    );
  }

  /// Arama sonuçları başlığı (Arama aktifken görünür)
  Widget _buildSearchResultsHeader() {
    final resultCount = viewModel.books.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.accentCyan.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 14.sp,
                    color: AppColors.accentCyan,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "ARAMA SONUÇLARI",
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: AppColors.accentCyan,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "$resultCount kitap",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 100.h,
      backgroundColor: AppColors.backgroundCanvas.withOpacity(0.8),
      elevation: 0,
      centerTitle: false,
      title: Text(
        "KİTAPP",
        style: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            ),
            child: IconButton(
              onPressed: () => NavigationUtil.navigateToProfile(context),
              icon: Icon(Icons.person_2_outlined,
                  color: AppColors.textPrimary, size: 22.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextFieldWidget(
      label: "ARAMA",
      hintText: "Kitap, yazar veya tür ara...",
      controller: viewModel.searchController,
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: viewModel.isSearchActive
          ? IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 20.sp,
                color: AppColors.accentCyan,
              ),
              onPressed: () {
                viewModel.searchController.clear();
                viewModel.reloadState();
              },
            )
          : null,
      onChanged: (_) => viewModel.reloadState(),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "TÜMÜ",
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.accentCyan,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalBooks(List<BookResponse> books) {
    if (books.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 290.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        padding: EdgeInsets.only(right: 24.w),
        separatorBuilder: (context, index) => SizedBox(width: 20.w),
        itemBuilder: (context, index) => SizedBox(
          width: 170.w,
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
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          children: HomeConstants.filters.map((filter) {
            final isSelected = viewModel.selectedFilter == filter;
            return Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: GestureDetector(
                onTap: () => viewModel.setFilter(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutExpo,
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.primaryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentLight
                          : Colors.white.withOpacity(0.08),
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                  ),
                  child: Text(
                    filter.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w500,
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecommendedGrid(BuildContext context) {
    final books = viewModel.books;
    final isSearching = viewModel.isSearchActive;

    if (books.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Arama durumuna göre farklı ikon
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: isSearching
                        ? AppColors.accentCyan.withOpacity(0.1)
                        : AppColors.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSearching
                        ? Icons.search_off_rounded
                        : Icons.auto_stories_outlined,
                    size: 28.sp,
                    color:
                        isSearching ? AppColors.accentCyan : AppColors.accent,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  isSearching ? 'SONUÇ BULUNAMADI' : 'HENÜZ KİTAP YOK',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  isSearching
                      ? '"${viewModel.searchController.text}" için sonuç bulunamadı.\nFarklı anahtar kelimeler deneyin.'
                      : 'Keşfetmeye başlamak için ilk kitabı ekle.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final screenW = MediaQuery.sizeOf(context).width;
    final pad = 24.w * 2;
    final crossSpacing = 20.w;
    const crossAxisCount = 2;
    final tileW = (screenW - pad - crossSpacing) / crossAxisCount;
    final coverH = tileW * 1.35;
    final textH = 80.h;
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
