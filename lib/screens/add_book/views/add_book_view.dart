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
import '../../../common_widgets/alert_dialog_widget.dart';
import '../viewmodels/add_book_view_model.dart';

/// Add Book View - Form for users to add new books
class AddBookView extends StatelessWidget {
  final AddBookViewModel viewModel;

  const AddBookView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTexts.addBook,
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
                    
                    // Book Name
                    TextFieldWidget(
                      textTitle: AppTexts.bookName,
                      textController: viewModel.nameController,
                      validator: Validators.emptyFieldValidator,
                      textIcon: Icons.book_outlined,
                      hintText: 'Kitap adını girin',
                    ),
                    
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Writer Name
                    TextFieldWidget(
                      textTitle: AppTexts.writerName,
                      textController: viewModel.writerController,
                      validator: Validators.emptyFieldValidator,
                      textIcon: Icons.person_outline,
                      hintText: 'Yazar adını girin',
                    ),
                    
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Genre Dropdown
                    _buildGenreDropdown(context),
                    
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Language Dropdown
                    _buildLanguageDropdown(context),
                    
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Description
                    TextFieldWidget(
                      textTitle: AppTexts.bookDescription,
                      textController: viewModel.descriptionController,
                      maxLines: 4,
                      textIcon: Icons.description_outlined,
                      hintText: 'Kitap açıklaması (opsiyonel)',
                    ),
                    
                    SizedBox(height: AppSizes.sizeXLarge.h),
                    
                    // Image Upload
                    ImagePickerWidget(
                      label: AppTexts.uploadImage,
                      selectedImage: viewModel.selectedImage,
                      onImageSelected: (image) {
                        viewModel.setSelectedImage(image);
                      },
                    ),
                    
                    SizedBox(height: AppSizes.sizeXLarge.h),
                    
                    // Add Book Button
                    ButtonWidget(
                      textTitle: AppTexts.addBook,
                      onTap: () => _handleAddBook(context),
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
                          borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
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

  Widget _buildGenreDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.bookType,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.sizeSmall.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
          ),
          child: DropdownButtonFormField<String>(
            value: viewModel.selectedGenre,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.category_outlined,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: AppEdgeInsets.symmetric(
                horizontal: AppSizes.sizeLarge,
                vertical: AppSizes.sizeLarge,
              ),
            ),
            items: viewModel.genres.map((genre) {
              return DropdownMenuItem(
                value: genre,
                child: Text(genre),
              );
            }).toList(),
            onChanged: (value) {
              viewModel.setGenre(value);
            },
            hint: Text('Tür seçin'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen bir tür seçin';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.bookLanguage,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.sizeSmall.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
          ),
          child: DropdownButtonFormField<String>(
            value: viewModel.selectedLanguage,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.language_outlined,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: AppEdgeInsets.symmetric(
                horizontal: AppSizes.sizeLarge,
                vertical: AppSizes.sizeLarge,
              ),
            ),
            items: viewModel.languages.map((language) {
              return DropdownMenuItem(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (value) {
              viewModel.setLanguage(value);
            },
            hint: Text('Dil seçin'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen bir dil seçin';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }


  Future<void> _handleAddBook(BuildContext context) async {
    if (!viewModel.formKey.currentState!.validate()) {
      return;
    }

    final success = await viewModel.addBook(context);
    
    if (success && context.mounted) {
      await AlertDialogWidget.showSuccessfulDialog(
        context,
        'Kitap başarıyla eklendi!',
      );
      
      if (context.mounted) {
        // Clear form
        viewModel.nameController.clear();
        viewModel.writerController.clear();
        viewModel.descriptionController.clear();
        viewModel.setGenre(null);
        viewModel.setLanguage(null);
      }
    }
  }
}
