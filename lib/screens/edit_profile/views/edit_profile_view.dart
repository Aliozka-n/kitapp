import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/constants/app_size.dart';
import '../../../base/constants/app_edge_insets.dart';
import '../../../base/constants/app_texts.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../common_widgets/image_picker_widget.dart';
import '../../../utils/validators_util.dart';
import '../../../utils/navigation_util.dart';
import '../../../common_widgets/alert_dialog_widget.dart';
import '../viewmodels/edit_profile_view_model.dart';

/// Edit Profile View - Profil düzenleme ekranı
class EditProfileView extends StatelessWidget {
  final EditProfileViewModel viewModel;

  const EditProfileView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = viewModel.user;

    if (user == null && !viewModel.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(AppTexts.editProfile)),
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
          AppTexts.editProfile,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppEdgeInsets.symmetric(horizontal: AppSizes.sizeXLarge),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSizes.sizeLarge.h),

                    // Profile Photo Upload
                    Center(
                      child: ImagePickerWidget(
                        label: 'Profil Fotoğrafı',
                        selectedImage: viewModel.selectedImage,
                        onImageSelected: (image) {
                          viewModel.setSelectedImage(image);
                        },
                        imageHeight: 150.h,
                        imageWidth: 150.w,
                      ),
                    ),

                    SizedBox(height: AppSizes.sizeXLarge.h),

                    // Name Field
                    TextFieldWidget(
                      textTitle: 'Ad Soyad',
                      textController: viewModel.nameController,
                      validator: Validators.emptyFieldValidator,
                      textIcon: Icons.person_outline,
                      hintText: 'Adınızı girin',
                    ),

                    SizedBox(height: AppSizes.sizeLarge.h),

                    // Email Field
                    TextFieldWidget(
                      textTitle: AppTexts.email,
                      textController: viewModel.emailController,
                      validator: Validators.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      textIcon: Icons.email_outlined,
                      hintText: 'ornek@email.com',
                      enabled: false, // Email değiştirilemez
                    ),

                    SizedBox(height: AppSizes.sizeLarge.h),

                    // İl Field
                    TextFieldWidget(
                      textTitle: 'İl',
                      textController: viewModel.ilController,
                      textIcon: Icons.location_city_outlined,
                      hintText: 'İl girin (opsiyonel)',
                    ),

                    SizedBox(height: AppSizes.sizeLarge.h),

                    // İlçe Field
                    TextFieldWidget(
                      textTitle: 'İlçe',
                      textController: viewModel.ilceController,
                      textIcon: Icons.location_on_outlined,
                      hintText: 'İlçe girin (opsiyonel)',
                    ),

                    SizedBox(height: AppSizes.sizeXLarge.h),

                    // Update Button
                    ButtonWidget(
                      textTitle: 'Profili Güncelle',
                      onTap: () => _handleUpdateProfile(context),
                      enabled: !viewModel.isLoading,
                      isLoading: viewModel.isLoading,
                    ),

                    SizedBox(height: AppSizes.sizeLarge.h),

                    // Error Message
                    if (viewModel.errorMessage != null)
                      Container(
                        padding: AppEdgeInsets.all(AppSizes.sizeMedium),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius:
                              BorderRadius.circular(AppSizes.sizeMedium.w),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.errorColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: AppSizes.sizeSmall.w),
                            Expanded(
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: AppColors.errorColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleUpdateProfile(BuildContext context) async {
    final success = await viewModel.updateProfile(context);

    if (success && context.mounted) {
      await AlertDialogWidget.showSuccessfulDialog(
        context,
        'Profil başarıyla güncellendi!',
      );

      if (context.mounted) {
        NavigationUtil.goBack(context);
      }
    }
  }
}

