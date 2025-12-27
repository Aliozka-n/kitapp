import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Colors - "Neo-Ethereal" Palette
/// "Futuristic, deep, and luminous"
class AppColors {
  // Primary Palette (Deep Space)
  static const primary = Color(0xFF0A0C10); // Deep Obsidian
  static const primaryLight = Color(0xFF1A1D23);
  static const primaryDark = Color(0xFF050608);

  // Accent Palette (Quantum Lume)
  static const accent = Color(0xFF6366F1); // Electric Indigo
  static const accentLight = Color(0xFF818CF8);
  static const accentCyan = Color(0xFF22D3EE); // Neon Cyan for secondary highlights
  static const accentSoft = Color(0xFFC7D2FE);

  // Secondary Palette (Stellar Mist)
  static const secondary = Color(0xFF94A3B8); // Cool Slate
  static const secondaryLight = Color(0xFFCBD5E1);

  // Background Colors - Cinematic Depth
  static const backgroundDark = Color(0xFF030406);
  static const backgroundCanvas = Color(0xFF0A0C10);
  static const cardBackground = Color(0xFF111418);
  static const glassBackground = Color(0x1AFFFFFF); // 10% white for glass effect

  // Text Colors
  static const textPrimary = Color(0xFFF8FAFC); // Off White
  static const textSecondary = Color(0xFF94A3B8); // Muted Slate
  static const textMuted = Color(0xFF64748B);
  static const textAccent = accentCyan;
  static const textWhite = Color(0xFFFFFFFF);

  // Neutral Colors
  static const grey = Color(0xFF334155);
  static const greyLight = Color(0xFF475569);
  static const greyDark = Color(0xFF1E293B);
  static const divider = Color(0xFF1E293B);

  // Status Colors
  static const errorColor = Color(0xFFEF4444); // Neon Rose
  static const errorLight = Color(0xFFFFEBEE);
  static const successColor = Color(0xFF10B981); // Emerald Glow
  static const successLight = Color(0xFFECFDF5);
  static const warningColor = Color(0xFFF59E0B);
  static const infoColor = Color(0xFF3B82F6);

  // Overlay Colors
  static const overlayDark = Color(0xCC030406); // 80% opacity
  static const glassBorder = Color(0x33FFFFFF); // 20% white border

  // Shadows - Luminous & Deep
  static const shadowColor = Color(0x4D000000); // 30% Black
  static const glowColor = Color(0x336366F1); // 20% Accent Glow
}

/// App Gradients - Ethereal & Cosmic
class AppGradients {
  static LinearGradient get cosmic => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6366F1), Color(0xFF22D3EE)],
      );

  static LinearGradient get obsidian => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primaryLight, AppColors.primary],
      );

  static LinearGradient get glass => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.12),
          Colors.white.withOpacity(0.04),
        ],
      );

  static LinearGradient get surface => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.cardBackground,
          AppColors.primary,
        ],
      );
}

/// App Shadows - High-End Floating depth
class AppShadows {
  static List<BoxShadow> get none => [];

  static List<BoxShadow> get glow => [
        BoxShadow(
          color: AppColors.accent.withOpacity(0.3),
          blurRadius: 20.r,
          offset: Offset(0, 4.h),
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get floating => [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 40.r,
          offset: Offset(0, 24.h),
          spreadRadius: -12,
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 24.r,
          offset: Offset(0, 8.h),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get innerGlow => [
        BoxShadow(
          color: Colors.white.withOpacity(0.05),
          blurRadius: 1.r,
          offset: const Offset(1, 1),
          spreadRadius: 0,
        ),
      ];
}

/// App Theme - "Neo-Ethereal" Design System
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundCanvas,
      primaryColor: AppColors.accent,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
        primary: AppColors.accent,
        secondary: AppColors.accentCyan,
        surface: AppColors.cardBackground,
        background: AppColors.backgroundCanvas,
        error: AppColors.errorColor,
        onPrimary: AppColors.textWhite,
        onSecondary: AppColors.textWhite,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),

      // Typography - High Personality Modernity
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 40.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        displaySmall: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontSize: 28.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.outfit(
          color: AppColors.accentCyan,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),

      // AppBar Theme - Glassy & Floating
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),
        titleTextStyle: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),

      // Card Theme - Glassmorphism Style
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
        ),
        color: AppColors.cardBackground,
        margin: EdgeInsets.zero,
      ),

      // Input Decoration - Sleek & Modern
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primaryLight,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted,
          fontSize: 14.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 20.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 24.h,
      ),
    );
  }

  // Maintaining lightTheme for fallback, but mapping it to a "Clean Modern" style
  static ThemeData get lightTheme => darkTheme; // For this futuristic pivot, we default to dark
}


