import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/constants/app_constants.dart';
import '../base/constants/app_size.dart';

/// Text Field Widget - Theme Aware
class TextFieldWidget extends StatelessWidget {
  final String? textTitle;
  final TextEditingController? textController;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final IconData? textIcon;
  final bool obscureText;
  final int? maxLength;
  final TextInputType keyboardType;
  final String? hintText;
  final bool enabled;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;

  const TextFieldWidget({
    Key? key,
    this.textTitle,
    this.textController,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.textIcon,
    this.obscureText = false,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.enabled = true,
    this.maxLines = 1,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (textTitle != null && textTitle!.isNotEmpty) ...[
          Text(
            textTitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: textController,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          obscureText: obscureText,
          maxLength: maxLength,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: obscureText ? 1 : maxLines,
          focusNode: focusNode,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon ??
                (textIcon != null
                    ? Icon(
                        textIcon,
                        color: AppColors.textSecondary,
                        size: 20.sp,
                      )
                    : null),
            suffixIcon: suffixIcon,
            counterText: '',
            // Theme data will handle borders and fill
          ),
        ),
      ],
    );
  }
}
