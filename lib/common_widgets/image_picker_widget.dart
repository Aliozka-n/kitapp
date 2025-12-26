import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../base/constants/app_constants.dart';
import '../base/constants/app_size.dart';
import '../base/constants/app_edge_insets.dart';

/// Image Picker Widget - Görsel seçme ve önizleme widget'ı
class ImagePickerWidget extends StatelessWidget {
  final File? selectedImage;
  final Function(File?) onImageSelected;
  final String? label;
  final double? imageHeight;
  final double? imageWidth;

  const ImagePickerWidget({
    Key? key,
    this.selectedImage,
    required this.onImageSelected,
    this.label,
    this.imageHeight,
    this.imageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.sizeSmall.h),
        ],
        
        // Seçili görsel varsa göster
        if (selectedImage != null) ...[
          Stack(
            children: [
              Container(
                height: imageHeight ?? 200.h,
                width: imageWidth ?? double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: AppSizes.sizeSmall.h,
                right: AppSizes.sizeSmall.w,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.errorColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textWhite,
                      size: 20.sp,
                    ),
                    onPressed: () => onImageSelected(null),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sizeMedium.h),
        ],
        
        // Görsel seç butonu
        OutlinedButton.icon(
          onPressed: () => _showImageSourceDialog(context),
          icon: Icon(
            selectedImage != null ? Icons.change_circle_outlined : Icons.image_outlined,
            color: AppColors.primary,
          ),
          label: Text(
            selectedImage != null ? 'Görseli Değiştir' : 'Görsel Seç',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primary),
            padding: AppEdgeInsets.symmetric(
              horizontal: AppSizes.sizeLarge,
              vertical: AppSizes.sizeLarge,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
            ),
          ),
        ),
      ],
    );
  }

  /// Görsel kaynağı seçim diyaloğu
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.sizeLarge.w),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: AppEdgeInsets.all(AppSizes.sizeLarge),
              child: Text(
                'Görsel Kaynağı Seç',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery);
              },
            ),
            SizedBox(height: AppSizes.sizeSmall.h),
          ],
        ),
      ),
    );
  }

  /// Görsel seç
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        onImageSelected(File(image.path));
      }
    } catch (e) {
      // Hata durumunda sessizce geç
      // İsterseniz burada bir snackbar gösterebilirsiniz
    }
  }
}

