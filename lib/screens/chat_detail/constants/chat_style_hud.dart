import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';

/// ChatDetail v5: "HUD / Neo-Ethereal Glass"
/// Glass panels + subtle particles + indigo/cyan accents.
class ChatHudStyle {
  ChatHudStyle._();

  // Palette - Linking to AppColors
  static const Color space = AppColors.primary;
  static const Color space2 = AppColors.backgroundCanvas;
  static const Color glass = Color(0x1AFFFFFF); // 10% white for glass
  static const Color glass2 = Color(0x0DFFFFFF); // 5% white

  static const Color cyan = AppColors.accentCyan;
  static const Color indigo = AppColors.accent;
  static const Color accent = AppColors.accent;

  static const Color text = AppColors.textPrimary;
  static const Color dim = AppColors.textSecondary;
  static const Color grid = Color(0xFF1E293B);

  static LinearGradient get bg => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.backgroundCanvas, AppColors.primaryDark],
      );

  static TextStyle title(double size, {Color? color}) => GoogleFonts.outfit(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color ?? text,
        height: 1.0,
        letterSpacing: 0.2,
      );

  static TextStyle label(double size, {Color? color}) => GoogleFonts.outfit(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color ?? dim,
        height: 1.0,
        letterSpacing: 1.5,
      );

  static TextStyle mono(double size, {Color? color}) => GoogleFonts.spaceMono(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? cyan,
        height: 1.0,
      );

  static TextStyle body(double size, {Color? color}) => GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? text,
        height: 1.45,
      );

  static List<BoxShadow> get glowCyan => [
        BoxShadow(
          color: cyan.withOpacity(0.15),
          blurRadius: 30.r,
          offset: Offset(0, 8.h),
        ),
      ];

  static List<BoxShadow> get glowIndigo => [
        BoxShadow(
          color: indigo.withOpacity(0.15),
          blurRadius: 30.r,
          offset: Offset(0, 8.h),
        ),
      ];

  static BorderSide get hudBorder => BorderSide(color: Colors.white.withOpacity(0.08), width: 1);
}


class ChatHudBackground extends StatelessWidget {
  final Widget child;

  const ChatHudBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(decoration: BoxDecoration(gradient: ChatHudStyle.bg)),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _GridPainter()),
          ),
        ),
        // Decorative Blobs - Refined for "Neo-Ethereal"
        Positioned(
          top: -150.h,
          right: -100.w,
          child: _Blob(color: ChatHudStyle.indigo, size: 500.w),
        ),
        Positioned(
          bottom: -150.h,
          left: -100.w,
          child: _Blob(color: ChatHudStyle.cyan, size: 400.w),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.08), color.withOpacity(0)],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Sparse stars/particles
    final rnd = math.Random(42);
    final star = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 60; i++) {
      star.color = Colors.white.withOpacity(0.03 + rnd.nextDouble() * 0.08);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        0.5 + rnd.nextDouble() * 1.5,
        star,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Glass panel wrapper for chat
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? color;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.boxShadow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppColors.glassBackground,
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: boxShadow,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}




