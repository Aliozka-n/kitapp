import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// ChatDetail "Night‑Print / Phosphor" style (feature-local; does not touch global theme)
class ChatStyle {
  ChatStyle._();

  // Core palette
  static const Color ink = Color(0xFF070A0F); // almost-black
  static const Color ink2 = Color(0xFF0B1020); // deep blue-black
  static const Color paper = Color(0xFFF6F2E8); // warm paper (for contrast elements)

  static const Color phosphor = Color(0xFFB7FF5A); // neon green
  static const Color fuchsia = Color(0xFFFF2E88); // hot pink
  static const Color cyan = Color(0xFF33D6FF); // electric cyan

  static const Color text = Color(0xFFE9ECF2);
  static const Color textDim = Color(0xFF9AA3B2);
  static const Color border = Color(0xFF20283A);
  static const Color danger = Color(0xFFFF4D4D);

  static LinearGradient get bgGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [ink2, ink],
      );

  static TextStyle titleStyle(double size) => GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: text,
        height: 1.0,
        letterSpacing: -0.2,
      );

  static TextStyle metaMono(double size, {Color? color}) => GoogleFonts.ibmPlexMono(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? textDim,
        height: 1.0,
        letterSpacing: 0.2,
      );

  static TextStyle body(double size, {Color? color}) => GoogleFonts.instrumentSans(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? text,
        height: 1.35,
      );

  static List<BoxShadow> get glowGreen => [
        BoxShadow(
          color: phosphor.withOpacity(0.22),
          blurRadius: 22.r,
          spreadRadius: 0,
          offset: Offset(0, 10.h),
        ),
      ];

  static List<BoxShadow> get glowPink => [
        BoxShadow(
          color: fuchsia.withOpacity(0.18),
          blurRadius: 26.r,
          offset: Offset(0, 12.h),
        ),
      ];
}

/// Background scanlines + subtle grain (cheap to paint).
class ChatScanlines extends StatelessWidget {
  final Widget child;

  const ChatScanlines({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // gradient base
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: ChatStyle.bgGradient),
          ),
        ),
        // soft blobs
        Positioned(
          top: -90.h,
          left: -70.w,
          child: _GlowBlob(color: ChatStyle.phosphor, size: 220.w),
        ),
        Positioned(
          bottom: -120.h,
          right: -90.w,
          child: _GlowBlob(color: ChatStyle.fuchsia, size: 260.w),
        ),
        Positioned(
          top: 0.22.sh,
          right: -60.w,
          child: _GlowBlob(color: ChatStyle.cyan, size: 190.w),
        ),
        // scanlines
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _ScanlinePainter(),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.22),
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;
    // horizontal scanlines
    for (double y = 0; y < size.height; y += 6) {
      final alpha = (0.05 + 0.04 * math.sin(y / 14)).clamp(0.02, 0.09);
      paint.color = Colors.white.withOpacity(alpha);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // subtle grain dots (sparse)
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final rnd = math.Random(7); // deterministic
    for (int i = 0; i < 220; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      dotPaint.color = Colors.white.withOpacity(0.035 + rnd.nextDouble() * 0.02);
      canvas.drawCircle(Offset(dx, dy), 0.6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


