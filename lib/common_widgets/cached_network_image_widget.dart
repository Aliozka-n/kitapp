import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../base/constants/app_constants.dart';
import 'shimmer_widget.dart';

/// Cached Network Image Widget - Optimized image loading with caching
class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? placeholderColor;
  final IconData? placeholderIcon;

  const CachedNetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.placeholderColor,
    this.placeholderIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width?.w,
      height: height?.h,
      fit: fit,
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildDefaultError(),
      memCacheWidth: width != null ? (width! * 2).toInt() : null,
      memCacheHeight: height != null ? (height! * 2).toInt() : null,
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildDefaultPlaceholder() {
    return ShimmerContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  Widget _buildDefaultError() {
    return Container(
      width: width?.w,
      height: height?.h,
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: borderRadius,
      ),
      child: Icon(
        placeholderIcon ?? Icons.image_not_supported,
        size: (height != null ? height! * 0.4 : 40).sp,
        color: AppColors.grey,
      ),
    );
  }
}

