import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../domain/enums/book_category.dart';
import '../../../utils/validators_util.dart';
import '../viewmodels/add_book_view_model.dart';

class AddBookView extends StatelessWidget {
  final AddBookViewModel viewModel;
  final VoidCallback? onBookAdded;

  const AddBookView({
    Key? key,
    required this.viewModel,
    this.onBookAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "KİTAP EKLE",
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                _buildImagePicker(context),
                SizedBox(height: 32.h),
                TextFieldWidget(
                  label: "KİTAP ADI",
                  controller: viewModel.nameController,
                  validator: Validators.emptyFieldValidator,
                ),
                SizedBox(height: 20.h),
                TextFieldWidget(
                  label: "YAZAR",
                  controller: viewModel.writerController,
                  validator: Validators.emptyFieldValidator,
                ),
                SizedBox(height: 20.h),
                _buildCategoryDropdown(context),
                SizedBox(height: 20.h),
                TextFieldWidget(
                  label: "AÇIKLAMA",
                  controller: viewModel.descriptionController,
                  hintText: "Kitap hakkında kısa bir bilgi...",
                ),
                SizedBox(height: 40.h),
                ButtonWidget(
                  text: "KAYDET VE PAYLAŞ",
                  isLoading: viewModel.isLoading,
                  onPressed: () async {
                    final success = await viewModel.addBook(context);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Kitap başarıyla eklendi.")),
                      );
                      onBookAdded?.call();
                    }
                  },
                ),
                SizedBox(height: 140.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TÜR",
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.accentCyan,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
              width: 1.5,
            ),
            boxShadow: AppShadows.card,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BookCategory>(
              value: viewModel.selectedCategory,
              isExpanded: true,
              dropdownColor: AppColors.primary,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accentCyan),
              hint: Text(
                "Tür seçin...",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
              items: viewModel.categories.map((category) {
                return DropdownMenuItem<BookCategory>(
                  value: category,
                  child: Text(
                    category.displayName,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) => viewModel.setCategory(value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.setSelectedImage(null), // TODO: Implement image picker
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
          boxShadow: AppShadows.card,
        ),
        child: viewModel.selectedImage != null
            ? Image.file(viewModel.selectedImage!, fit: BoxFit.cover)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_rounded, size: 48, color: AppColors.accentCyan),
                  SizedBox(height: 12.h),
                  Text(
                    "KİTAP KAPAĞI EKLE",
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
