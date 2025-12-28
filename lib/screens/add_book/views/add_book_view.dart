import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
                    if (context.mounted) {
                      if (success) {
                        _showSuccessSnackBar(context, "Kitap başarıyla eklendi.");
                        onBookAdded?.call();
                      } else if (viewModel.errorMessage != null) {
                        _showErrorSnackBar(context, viewModel.errorMessage!);
                      }
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
      onTap: () => _showImageSourceActionSheet(context),
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
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: Image.file(
                      viewModel.selectedImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () {
                        viewModel.setSelectedImage(null);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.textPrimary,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              )
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

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            if (viewModel.selectedImage != null)
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: AppColors.errorColor),
                title: Text(
                  'Görseli Kaldır',
                  style: GoogleFonts.plusJakartaSans(color: AppColors.errorColor),
                ),
                onTap: () {
                  viewModel.setSelectedImage(null);
                  Navigator.of(context).pop();
                },
              ),
            ListTile(
              leading: Icon(Icons.photo_library_rounded, color: AppColors.accentCyan),
              title: Text(
                'Galeriden Seç',
                style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
              ),
              onTap: () {
                _pickImage(context, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_rounded, color: AppColors.accent),
              title: Text(
                'Kamera ile Çek',
                style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
              ),
              onTap: () {
                _pickImage(context, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      viewModel.setSelectedImage(File(pickedFile.path));
    }
  }

  /// Success snackbar göster
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.textPrimary, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Error snackbar göster
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.textPrimary, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
