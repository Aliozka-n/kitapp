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
        SizedBox(height: 28.h),
        Text(
          name,
          style: GoogleFonts.outfit(
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 14.sp, color: AppColors.accentCyan),
                  SizedBox(width: 6.w),
                  Text(
                    location,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          email,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.sp,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 110.w,
      height: 110.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppGradients.cosmic,
        boxShadow: AppShadows.glow,
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: ClipOval(
          child: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
              ? Image.network(
                  user!.avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildInitials(),
                )
              : _buildInitials(),
        ),
      ),
    );
  }

  Widget _buildInitials() {
    final initials = user?.name != null && user!.name!.isNotEmpty
        ? user!.name![0].toUpperCase()
        : "?";
    return Center(
      child: Text(
        initials,
        style: GoogleFonts.outfit(
          color: AppColors.accentLight,
          fontSize: 44.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

