import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../domain/dtos/user_dto.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserResponse? user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? "Misafir Kullanıcı";
    final email = user?.email ?? "";
    final location = "${user?.il ?? 'Konum Belirtilmedi'}, ${user?.ilce ?? ''}";

    return Column(
      children: [
        _buildAvatar(),
        SizedBox(height: 24.h),
        Text(
          name.toUpperCase(),
          style: GoogleFonts.syne(
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.accent),
            SizedBox(width: 4.w),
            Text(
              location,
              style: GoogleFonts.instrumentSans(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          email,
          style: GoogleFonts.instrumentSans(
            fontSize: 12.sp,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: AppShadows.sharp,
      ),
      child: Center(
        child: user?.avatarUrl != null
            ? Image.network(
                user!.avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitials(),
              )
            : _buildInitials(),
      ),
    );
  }

  Widget _buildInitials() {
    final initials = user?.name != null && user!.name!.isNotEmpty
        ? user!.name![0].toUpperCase()
        : "?";
    return Text(
      initials,
      style: GoogleFonts.syne(
        color: AppColors.textWhite,
        fontSize: 40.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
