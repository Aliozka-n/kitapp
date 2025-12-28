import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../base/constants/app_constants.dart';

/// Reusable Dropdown Widget - İl/İlçe ve diğer seçimler için
class DropdownWidget<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool isEnabled;

  const DropdownWidget({
    Key? key,
    required this.label,
    this.hintText,
    this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.accentCyan,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        FormField<T>(
          initialValue: value,
          validator: validator,
          builder: (FormFieldState<T> field) {
            final hasError = field.hasError && field.errorText != null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: hasError
                          ? AppColors.errorColor
                          : Colors.white.withOpacity(0.05),
                      width: 1.5,
                    ),
                    boxShadow: AppShadows.card,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      value: value,
                      isExpanded: true,
                      isDense: false,
                      dropdownColor: AppColors.primaryLight,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isEnabled
                            ? AppColors.accentCyan
                            : AppColors.textMuted,
                      ),
                      hint: Text(
                        hintText ?? "Seçiniz...",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                      items: items.map((item) {
                        return DropdownMenuItem<T>(
                          value: item,
                          child: Text(
                            itemLabel(item),
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: isEnabled
                          ? (T? newValue) {
                              onChanged?.call(newValue);
                              field.didChange(newValue);
                            }
                          : null,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                if (hasError) ...[
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      field.errorText!,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.errorColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
