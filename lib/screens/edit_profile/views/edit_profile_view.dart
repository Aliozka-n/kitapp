import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../base/constants/app_constants.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../viewmodels/edit_profile_view_model.dart';

class EditProfileView extends StatelessWidget {
  final EditProfileViewModel viewModel;

  const EditProfileView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "PROFİLİ DÜZENLE",
          style: GoogleFonts.syne(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: () => _handleBack(context),
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              SizedBox(height: 32.h),
              _buildAvatarEdit(context),
              SizedBox(height: 48.h),
              _buildFormFields(),
              SizedBox(height: 48.h),
              _buildSaveButton(context),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarEdit(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              border: Border.all(color: AppColors.primary, width: 2),
              boxShadow: AppShadows.sharp,
            ),
            child: _buildAvatarContent(),
          ),
          Positioned(
            right: -8.w,
            bottom: -8.h,
            child: GestureDetector(
              onTap: () => _showImageSourceActionSheet(context),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  shape: BoxShape.rectangle,
                ),
                child: const Icon(Icons.camera_alt,
                    color: AppColors.textWhite, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (viewModel.selectedImage != null) {
      return Image.file(viewModel.selectedImage!, fit: BoxFit.cover);
    }
    if (viewModel.imageUrl != null) {
      return Image.network(viewModel.imageUrl!, fit: BoxFit.cover);
    }
    return Center(
      child: Text(
        viewModel.user?.name?[0].toUpperCase() ?? "?",
        style: GoogleFonts.syne(
          color: AppColors.textWhite,
          fontSize: 40.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFieldWidget(
          label: "AD SOYAD",
          hintText: "Adınızı ve soyadınızı girin",
          controller: viewModel.nameController,
          validator: (v) => v!.isEmpty ? "Lütfen adınızı girin" : null,
        ),
        SizedBox(height: 24.h),
        TextFieldWidget(
          label: "E-POSTA",
          hintText: "E-posta adresinizi girin",
          controller: viewModel.emailController,
          readOnly: true,
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(
                label: "ŞEHİR",
                hintText: "İl",
                controller: viewModel.ilController,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextFieldWidget(
                label: "İLÇE",
                hintText: "İlçe",
                controller: viewModel.ilceController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return GestureDetector(
      onTap: viewModel.isLoading ? null : () => _handleSave(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: viewModel.isFormChanged ? AppColors.primary : AppColors.grey,
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: viewModel.isFormChanged ? AppShadows.sharp : null,
        ),
        child: Center(
          child: viewModel.isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                  ),
                )
              : Text(
                  "KAYDET",
                  style: GoogleFonts.syne(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                    letterSpacing: 1.5,
                  ),
                ),
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundLight,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeriden Seç'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera ile Çek'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      viewModel.setSelectedImage(File(pickedFile.path));
    }
  }

  void _handleSave(BuildContext context) async {
    final success = await viewModel.updateProfile(context);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil başarıyla güncellendi')),
      );
      Navigator.pop(context);
    } else if (viewModel.errorMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage!)),
      );
    }
  }

  void _handleBack(BuildContext context) {
    if (viewModel.isFormChanged) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("KAYDEDİLMEMİŞ DEĞİŞİKLİKLER",
              style: GoogleFonts.syne(fontWeight: FontWeight.w800)),
          content: Text(
              "Yaptığınız değişiklikler kaybolacak. Çıkmak istiyor musunuz?",
              style: GoogleFonts.instrumentSans()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("HAYIR",
                  style: GoogleFonts.syne(color: AppColors.primary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("EVET",
                  style: GoogleFonts.syne(color: AppColors.errorColor)),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
