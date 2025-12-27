import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_stat_tile_widget.dart';
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
      backgroundColor: AppColors.backgroundLight,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: viewModel.refresh,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    ProfileHeaderWidget(user: viewModel.user),
                    SizedBox(height: 32.h),
                    _buildStatsGrid(),
                    SizedBox(height: 40.h),
                    ProfileTabSwitcherWidget(
                      selectedIndex: viewModel.selectedTabIndex,
                      onTabChanged: viewModel.setTabIndex,
                    ),
                    SizedBox(height: 24.h),
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
                    SizedBox(height: 48.h),
                    _buildLogoutButton(context),
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppColors.backgroundLight,
      expandedHeight: 80.h,
      centerTitle: false,
      title: Text(
        "PROFİL",
        style: GoogleFonts.syne(
          color: AppColors.textPrimary,
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => NavigationUtil.navigateToEditProfile(context),
          icon: const Icon(Icons.edit_note, size: 28),
        ),
        SizedBox(width: 16.w),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: ProfileStatTileWidget(
            label: "KİTAPLAR",
            value: viewModel.sharedBooksCount.toString(),
            icon: Icons.auto_stories_outlined,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ProfileStatTileWidget(
            label: "TAKASLAR",
            value: "12",
            icon: Icons.swap_horiz_outlined,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ProfileStatTileWidget(
            label: "PUAN",
            value: "4.8",
            icon: Icons.star_outline,
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

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ProfileBookCardWidget(
            book: books[index],
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

  Widget _buildActionList(BuildContext context) {
    return Column(
      children: [
        ProfileActionTileWidget(
          title: "Kütüphanem",
          icon: Icons.bookmark_outline,
          onTap: () {},
        ),
        ProfileActionTileWidget(
          title: "Favorilerim",
          icon: Icons.favorite_outline,
          onTap: () {},
        ),
        ProfileActionTileWidget(
          title: "Ayarlar",
          icon: Icons.settings_outlined,
          onTap: () {},
        ),
        ProfileActionTileWidget(
          title: "Yardım ve Destek",
          icon: Icons.help_outline,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.signOut(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.errorColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.errorColor.withOpacity(0.1),
              offset: Offset(4.w, 4.h),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "ÇIKIŞ YAP",
            style: GoogleFonts.syne(
              color: AppColors.errorColor,
              fontWeight: FontWeight.w800,
              fontSize: 14.sp,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
