import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_action_tile_widget.dart';
import '../widgets/profile_tab_switcher_widget.dart';
import '../widgets/profile_book_card_widget.dart';
import '../widgets/profile_empty_state_widget.dart';

class ProfileView extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCanvas,
      body: Stack(
        children: [
          // Background Decorative Glow
          Positioned(
            top: -50.h,
            left: -50.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.05),
                    blurRadius: 100.r,
                    spreadRadius: 50.r,
                  ),
                ],
              ),
            ),
          ),

          RefreshIndicator(
            color: AppColors.accentCyan,
            backgroundColor: AppColors.primaryLight,
            onRefresh: viewModel.refresh,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 12.h),
                        ProfileHeaderWidget(user: viewModel.user),
                        SizedBox(height: 32.h),
                        ProfileTabSwitcherWidget(
                          selectedIndex: viewModel.selectedTabIndex,
                          onTabChanged: viewModel.setTabIndex,
                        ),
                        SizedBox(height: 28.h),
                      ],
                    ),
                  ),
                ),
                _buildTabContent(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 24.h),
                        _buildActionList(context),
                        SizedBox(height: 54.h),
                        _buildLogoutButton(context),
                        SizedBox(height: 140.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppColors.backgroundCanvas.withOpacity(0.8),
      elevation: 0,
      centerTitle: true,
      title: Text(
        "PROFİL",
        style: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
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
              onPressed: () => NavigationUtil.navigateToEditProfile(context),
              icon: Icon(Icons.tune_rounded,
                  color: AppColors.accentCyan, size: 20.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(BuildContext context) {
    final books = viewModel.selectedTabIndex == 0
        ? viewModel.myBooks
        : viewModel.favoriteBooks;

    if (books.isEmpty) {
      return SliverToBoxAdapter(
        child: ProfileEmptyStateWidget(
          message: viewModel.selectedTabIndex == 0
              ? "Henüz kitap paylaşmadın."
              : "Henüz favori kitabın yok.",
        ),
      );
    }

    // Calculate a safe aspect ratio to prevent overflows
    final screenW = MediaQuery.sizeOf(context).width;
    final pad = 24.w * 2;
    final crossSpacing = 20.w;
    const crossAxisCount = 2;
    final tileW = (screenW - pad - crossSpacing) / crossAxisCount;
    final coverH = tileW * 1.35;
    final textH = 85.h;
    final tileH = coverH + textH;
    final dynamicRatio = tileW / tileH;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 24.h,
          crossAxisSpacing: 20.w,
          childAspectRatio: dynamicRatio,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final book = books[index];
            return ProfileBookCardWidget(
              book: book,
              onTap: () => NavigationUtil.navigateToBookDetail(
                context,
                book.id ?? "",
              ),
            );
          },
          childCount: books.length,
        ),
      ),
    );
  }

  Widget _buildActionList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          ProfileActionTileWidget(
            title: "Ayarlar",
            icon: Icons.settings_outlined,
            onTap: () => NavigationUtil.navigateToSettings(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.signOut(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
              color: AppColors.errorColor.withOpacity(0.3), width: 1.5),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded,
                  color: AppColors.errorColor, size: 20.sp),
              SizedBox(width: 12.w),
              Text(
                "ÇIKIŞ YAP",
                style: GoogleFonts.outfit(
                  color: AppColors.errorColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
