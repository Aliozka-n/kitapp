import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// ChatDetail v5: "HUD / Sci‑Fi Glass"
/// Glass panels + grid overlay + cyan/acid accents.
class ChatHudStyle {
  ChatHudStyle._();

  // Palette
  static const Color space = Color(0xFF05070C);
  static const Color space2 = Color(0xFF070C18);
  static const Color glass = Color(0xAA0B1224); // translucent deep navy
  static const Color glass2 = Color(0x660B1224);

  static const Color cyan = Color(0xFF2EF3FF);
  static const Color acid = Color(0xFFB7FF5A);
  static const Color violet = Color(0xFF8C7CFF);
  static const Color pink = Color(0xFFFF3B5C);
  static const Color danger = Color(0xFFFF3B5C);

  static const Color text = Color(0xFFEAF2FF);
  static const Color dim = Color(0xFF9AA7C2);
  static const Color grid = Color(0xFF1D2A44);

  static LinearGradient get bg => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [space2, space],
      );

  static TextStyle title(double size, {Color? color}) => GoogleFonts.orbitron(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color ?? text,
        height: 1.0,
        letterSpacing: 0.2,
      );

  static TextStyle label(double size, {Color? color}) => GoogleFonts.ibmPlexMono(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color ?? dim,
        height: 1.0,
        letterSpacing: 0.6,
      );

  static TextStyle mono(double size, {Color? color}) => GoogleFonts.ibmPlexMono(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? dim,
        height: 1.0,
      );

  static TextStyle body(double size, {Color? color}) => GoogleFonts.instrumentSans(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? text,
        height: 1.35,
      );

  static List<BoxShadow> get glowCyan => [
        BoxShadow(
          color: cyan.withOpacity(0.18),
          blurRadius: 28.r,
          offset: Offset(0, 14.h),
        ),
      ];

  static List<BoxShadow> get glowAcid => [
        BoxShadow(
          color: acid.withOpacity(0.16),
          blurRadius: 26.r,
          offset: Offset(0, 14.h),
        ),
      ];

  static List<BoxShadow> get glowPink => [
        BoxShadow(
          color: pink.withOpacity(0.16),
          blurRadius: 26.r,
          offset: Offset(0, 14.h),
        ),
      ];

  static BorderSide get hudBorder => BorderSide(color: cyan.withOpacity(0.55), width: 1);
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
        Positioned(
          top: -120.h,
          right: -120.w,
          child: _Blob(color: ChatHudStyle.cyan, size: 280.w),
        ),
        Positioned(
          bottom: -160.h,
          left: -160.w,
          child: _Blob(color: ChatHudStyle.violet, size: 320.w),
        ),
        Positioned(
          top: 0.34.sh,
          left: -140.w,
          child: _Blob(color: ChatHudStyle.acid, size: 240.w),
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
          colors: [color.withOpacity(0.22), color.withOpacity(0)],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ChatHudStyle.grid.withOpacity(0.35);

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // subtle diagonal “scan” lines
    final scan = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ChatHudStyle.cyan.withOpacity(0.05);
    for (double d = -size.height; d < size.width; d += 90) {
      canvas.drawLine(Offset(d, 0), Offset(d + size.height, size.height), scan);
    }

    // sparse stars
    final rnd = math.Random(5);
    final star = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 140; i++) {
      star.color = Colors.white.withOpacity(0.03 + rnd.nextDouble() * 0.05);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        0.6 + rnd.nextDouble() * 0.7,
        star,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simple glass panel wrapper (blur + border + subtle gradient)
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: ChatHudStyle.glass,
            borderRadius: borderRadius,
            border: Border.all(color: ChatHudStyle.cyan.withOpacity(0.45), width: 1),
            boxShadow: boxShadow,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ChatHudStyle.glass.withOpacity(0.85),
                ChatHudStyle.glass2.withOpacity(0.45),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}


