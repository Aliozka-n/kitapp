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
      backgroundColor: AppColors.backgroundLight,
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
              prefixIcon: const Icon(Icons.search),
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
              color: AppColors.secondaryLight,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(Icons.search_off_outlined,
                size: 64, color: AppColors.primary),
          ),
          SizedBox(height: 24.h),
          Text(
            "SONUÇ BULUNAMADI",
            style: GoogleFonts.syne(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Farklı anahtar kelimeler denemeye ne dersin?",
            textAlign: TextAlign.center,
            style: GoogleFonts.instrumentSans(
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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      itemCount: viewModel.searchResults.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final book = viewModel.searchResults[index];
        return InkWell(
          onTap: () =>
              NavigationUtil.navigateToBookDetail(context, book.id ?? ""),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: const Icon(Icons.book,
                      size: 24, color: AppColors.primary),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.name?.toUpperCase() ?? "İSİMSİZ",
                        style: GoogleFonts.syne(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        book.writer ?? "Yazar Belirtilmemiş",
                        style: GoogleFonts.instrumentSans(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: AppColors.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}
