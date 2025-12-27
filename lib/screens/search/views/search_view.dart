import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/search_view_model.dart';

class SearchView extends StatelessWidget {
  final SearchViewModel viewModel;

  const SearchView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCanvas,
      appBar: AppBar(
        title: const Text("KEŞFET"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: TextFieldWidget(
              label: "ARAMA",
              hintText: "Kitap, yazar veya kategori...",
              controller: viewModel.searchController,
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (v) => viewModel.search(v),
            ),
          ),
          Expanded(
            child: viewModel.searchResults.isEmpty
                ? _buildEmptyState()
                : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
            ),
            child: Icon(Icons.search_off_rounded, size: 64.sp, color: AppColors.accent),
          ),
          SizedBox(height: 24.h),
          Text(
            "SONUÇ BULUNAMADI",
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "Farklı anahtar kelimeler denemeye ne dersin?",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      itemCount: viewModel.searchResults.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final book = viewModel.searchResults[index];
        return InkWell(
          onTap: () =>
              NavigationUtil.navigateToBookDetail(context, book.id ?? ""),
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyDark,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(Icons.auto_stories_rounded,
                      size: 24, color: AppColors.accentCyan),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.name ?? "İsimsiz",
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        book.writer ?? "Yazar Belirtilmemiş",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 20.sp, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

}
