import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/constants/app_size.dart';
import '../../../base/constants/app_edge_insets.dart';
import '../../../base/constants/app_texts.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../common_widgets/alert_dialog_widget.dart';
import '../../../common_widgets/empty_state_widget.dart';
import '../../../common_widgets/book_card_shimmer.dart';
import '../../../utils/navigation_util.dart';
import '../../home/widgets/book_card_widget.dart';
import '../viewmodels/profile_view_model.dart';

/// Profile View - User profile screen
class ProfileView extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = viewModel.user;
    
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(AppTexts.profile)),
        body: Center(
          child: viewModel.errorMessage != null
              ? Text(viewModel.errorMessage!)
              : CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTexts.profile,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Pull-to-refresh için gerekli
          child: Padding(
            padding: AppEdgeInsets.all(AppSizes.sizeXLarge),
            child: Column(
            children: [
              // Profile Photo
              CircleAvatar(
                radius: 60.r,
                backgroundColor: AppColors.primary,
                child: Text(
                  (user.name ?? 'U')[0].toUpperCase(),
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              
              SizedBox(height: AppSizes.sizeLarge.h),
              
              // Username
              Text(
                user.name ?? 'Kullanıcı',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              SizedBox(height: AppSizes.sizeSmall.h),
              
              // Email
              Text(
                user.email ?? '',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
              ),
              
              SizedBox(height: AppSizes.sizeXLarge.h),
              
              // Shared Books Count
              Container(
                padding: AppEdgeInsets.all(AppSizes.sizeLarge),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
                  boxShadow: AppShadows.cardShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book,
                      color: AppColors.primary,
                      size: 32.sp,
                    ),
                    SizedBox(width: AppSizes.sizeMedium.w),
                    Column(
                      children: [
                        Text(
                          '${viewModel.sharedBooksCount}',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          AppTexts.sharedBooks,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: AppSizes.sizeXLarge.h),
              
              // Tabs
              _buildTabs(context),
              
              SizedBox(height: AppSizes.sizeLarge.h),
              
              // Books List
              _buildBooksList(context),
              
              SizedBox(height: AppSizes.sizeXXLarge.h),
              
              // Edit Profile Button
              ButtonWidget(
                textTitle: AppTexts.editProfile,
                onTap: () {
                  NavigationUtil.navigateToPage(
                    context,
                    NavigationUtil.editProfileScreen,
                  );
                },
                isOutlined: true,
                color: AppColors.primary,
                textColor: AppColors.primary,
              ),
              
              SizedBox(height: AppSizes.sizeLarge.h),
              
              // Logout Button
              ButtonWidget(
                textTitle: AppTexts.logout,
                onTap: () => _handleLogout(context),
                color: AppColors.errorColor,
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await AlertDialogWidget.showConfirmationDialog(
      context,
      'Çıkış yapmak istediğinize emin misiniz?',
      confirmText: 'Çıkış Yap',
      cancelText: 'İptal',
    );
    
    if (confirmed && context.mounted) {
      await viewModel.logout(context);
      if (context.mounted) {
        NavigationUtil.navigateAndRemoveUntil(
          context,
          NavigationUtil.loginScreen,
        );
      }
    }
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.setTabIndex(0),
              child: Container(
                padding: AppEdgeInsets.symmetric(
                  vertical: AppSizes.sizeMedium,
                ),
                decoration: BoxDecoration(
                  color: viewModel.selectedTabIndex == 0
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
                ),
                child: Text(
                  'Kitaplarım',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: viewModel.selectedTabIndex == 0
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: viewModel.selectedTabIndex == 0
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.setTabIndex(1),
              child: Container(
                padding: AppEdgeInsets.symmetric(
                  vertical: AppSizes.sizeMedium,
                ),
                decoration: BoxDecoration(
                  color: viewModel.selectedTabIndex == 1
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
                ),
                child: Text(
                  'Favorilerim',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: viewModel.selectedTabIndex == 1
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: viewModel.selectedTabIndex == 1
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksList(BuildContext context) {
    final books = viewModel.selectedTabIndex == 0
        ? viewModel.myBooks
        : viewModel.favoriteBooks;

    if (viewModel.isLoading && books.isEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: AppSizes.sizeMedium.w,
          mainAxisSpacing: AppSizes.sizeMedium.h,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return BookCardShimmer();
        },
      );
    }

    if (books.isEmpty) {
      return EmptyStateWidget.generic(
        icon: viewModel.selectedTabIndex == 0
            ? Icons.book_outlined
            : Icons.favorite_border,
        title: viewModel.selectedTabIndex == 0
            ? 'Henüz kitap eklemediniz'
            : 'Henüz favori kitabınız yok',
        message: viewModel.selectedTabIndex == 0
            ? 'İlk kitabınızı ekleyerek başlayın!'
            : 'Beğendiğiniz kitapları favorilerinize ekleyin',
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: AppSizes.sizeMedium.w,
        mainAxisSpacing: AppSizes.sizeMedium.h,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
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
