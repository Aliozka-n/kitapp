import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../common_widgets/text_field_widget.dart';
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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("KİTAP EKLE"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
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
              TextFieldWidget(
                label: "TÜR",
                controller: viewModel.typeController,
              ),
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
                    // Tab içinde olduğumuz için Navigator.pop yerine parent'a haber ver.
                    // (Pop, Home route'unu da düşürüp siyah ekrana bırakabiliyordu.)
                    onBookAdded?.call();
                  }
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.setSelectedImage(null), // TODO: Implement image picker
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: AppShadows.sharp,
        ),
        child: viewModel.selectedImage != null
            ? Image.file(viewModel.selectedImage!, fit: BoxFit.cover)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_outlined, size: 48, color: AppColors.primary),
                  SizedBox(height: 12.h),
                  Text(
                    "KİTAP KAPAĞI EKLE",
                    style: GoogleFonts.syne(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
