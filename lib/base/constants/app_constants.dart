import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App Colors - Editorial & Refined Palette
/// "Warm, sophisticated, and book-focused"
class AppColors {
  // Primary Palette (Editorial)
  static const primary = Color(0xFF2C3E50); // Midnight Blue / Charcoal
  static const primaryLight = Color(0xFF34495E);
  static const primaryDark = Color(0xFF1A252F);

  // Accent Palette (Warmth)
  static const accent = Color(0xFFD35400); // Burnt Orange / Terracotta
  static const accentLight = Color(0xFFE67E22);
  static const accentSoft = Color(0xFFFAD7A0);

  // Secondary Colors
  static const secondary = Color(0xFF16A085); // Muted Teal
  static const secondaryLight = Color(0xFF1ABC9C);

  // Background Colors - Paper & Ink
  static const backgroundLight = Color(0xFFF9F7F2); // Warm Cream / Paper
  static const backgroundWhite = Color(0xFFFFFFFF);
  static const backgroundDark = Color(0xFF121212);
  static const cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const textPrimary = Color(0xFF2C3E50); // Midnight Blue
  static const textSecondary = Color(0xFF7F8C8D); // Slate Grey
  static const textLight = Color(0xFF95A5A6);
  static const textWhite = Color(0xFFFFFFFF);
  // Legacy support for older code
  static const textDark = textPrimary;

  // Neutral Colors
  static const grey = Color(0xFFBDC3C7);
  static const greyLight = Color(0xFFECF0F1);
  static const greyDark = Color(0xFF7F8C8D);
  static const divider = Color(0xFFE0E0E0);

  // Status Colors
  static const errorColor = Color(0xFFC0392B); // Deep Red
  static const errorLight = Color(0xFFF9EBEA);
  static const successColor = Color(0xFF27AE60); // Forest Green
  static const successLight = Color(0xFFE8F8F5);
  static const warningColor = Color(0xFFF39C12);
  static const infoColor = Color(0xFF2980B9);

  // Shadows
  static const shadowColor = Color(0x1A2C3E50); // Navy hint in shadow

  // Overlay Colors
  static const overlayLight = Color(0x80F9F7F2); // 50% opacity backgroundLight
  static const overlayDark = Color(0x80121212);
}

/// App Gradients - Subtle & Atmospheric
class AppGradients {
  static LinearGradient get primaryGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.primary, AppColors.primaryLight],
      );

  static LinearGradient get accentGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.accent, AppColors.accentLight],
      );

  static LinearGradient get paperGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.backgroundLight, AppColors.backgroundWhite],
        stops: [0.0, 1.0],
      );

  // Legacy/Alias for compatibility with new design
  static LinearGradient get backgroundGradient => paperGradient;
}

/// App Shadows - Soft & Diffused
class AppShadows {
  static List<BoxShadow> get none => [];

  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 10.r,
          offset: Offset(0, 4.h),
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.shadowColor.withOpacity(0.08),
          blurRadius: 16.r,
          offset: Offset(0, 8.h),
          spreadRadius: 0,
        ),
      ];

  // Alias for legacy code
  static List<BoxShadow> get cardShadow => card;
  static List<BoxShadow> get small => soft;
  static List<BoxShadow> get large => floating;

  static List<BoxShadow> get floating => [
        BoxShadow(
          color: AppColors.shadowColor.withOpacity(0.15),
          blurRadius: 24.r,
          offset: Offset(0, 12.h),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.3),
          blurRadius: 12.r,
          offset: Offset(0, 6.h),
          spreadRadius: 0,
        ),
      ];
}

/// App Theme - Editorial Design System
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      primaryColor: AppColors.primary,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        tertiary: AppColors.secondary,
        surface: AppColors.cardBackground,
        background: AppColors.backgroundLight,
        error: AppColors.errorColor,
        onPrimary: AppColors.textWhite,
        onSecondary: AppColors.textWhite,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),

      // Typography (Simulating Serif with Font Weights/Spacing if custom font not avail)
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32.sp,
          fontWeight: FontWeight.w800, // Bold serif feel
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.1,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: false, // Editorial align left often looks better
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r), // More structured
          side: const BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
        color: AppColors.cardBackground,
        margin: EdgeInsets.zero,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundWhite,
        hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r), // Standard rounded
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.r), // Not pill, slightly rounded
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
