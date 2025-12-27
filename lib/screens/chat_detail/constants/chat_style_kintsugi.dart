import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// ChatDetail v3: "Kintsugi Paper / Indigo & Gold"
/// Warm paper background + indigo ink + gold seams.
class ChatKintsugiStyle {
  ChatKintsugiStyle._();

  static const Color paper = Color(0xFFFBF3E6);
  static const Color paper2 = Color(0xFFF3E7D6);
  static const Color ink = Color(0xFF10213A); // indigo ink
  static const Color inkSoft = Color(0xFF21395C);
  static const Color charcoal = Color(0xFF2C2B28);
  static const Color gold = Color(0xFFD7B24C);
  static const Color gold2 = Color(0xFFFFD88A);
  static const Color clay = Color(0xFFE16A54);
  static const Color border = Color(0xFF1B2E4A);
  static const Color danger = Color(0xFFB00020);
  static const Color dim = Color(0xFF6E6A63);

  static LinearGradient get bg => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [paper, paper2],
      );

  static TextStyle title(double size) => GoogleFonts.unna(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: ink,
        height: 1.0,
        letterSpacing: -0.2,
      );

  static TextStyle mono(double size, {Color? color}) => GoogleFonts.splineSansMono(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? dim,
        height: 1.0,
        letterSpacing: 0.2,
      );

  static TextStyle body(double size, {Color? color}) => GoogleFonts.instrumentSans(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? charcoal,
        height: 1.35,
      );

  static List<BoxShadow> get softLift => [
        BoxShadow(
          color: ink.withOpacity(0.08),
          blurRadius: 24.r,
          offset: Offset(0, 12.h),
          spreadRadius: -6,
        ),
      ];

  static List<BoxShadow> get goldGlow => [
        BoxShadow(
          color: gold.withOpacity(0.22),
          blurRadius: 28.r,
          offset: Offset(0, 12.h),
        ),
      ];
}

/// Background: warm paper + gold seams (kintsugi) + subtle speckles.
class ChatKintsugiBackground extends StatelessWidget {
  final Widget child;

  const ChatKintsugiBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(decoration: BoxDecoration(gradient: ChatKintsugiStyle.bg)),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _KintsugiPainter()),
          ),
        ),
        child,
      ],
    );
  }
}

class _KintsugiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(13);

    // Speckles
    final speck = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 260; i++) {
      speck.color = ChatKintsugiStyle.ink.withOpacity(0.03 + rnd.nextDouble() * 0.03);
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      canvas.drawCircle(Offset(dx, dy), 0.6 + rnd.nextDouble() * 0.5, speck);
    }

    // Gold seams
    final seam = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final start = Offset(
        size.width * (0.08 + rnd.nextDouble() * 0.2),
        size.height * (0.15 + rnd.nextDouble() * 0.2),
      );
      final end = Offset(
        size.width * (0.75 + rnd.nextDouble() * 0.2),
        size.height * (0.65 + rnd.nextDouble() * 0.25),
      );

      final path = Path()..moveTo(start.dx, start.dy);
      final mid1 = Offset(
        size.width * (0.35 + rnd.nextDouble() * 0.15),
        size.height * (0.32 + rnd.nextDouble() * 0.18),
      );
      final mid2 = Offset(
        size.width * (0.55 + rnd.nextDouble() * 0.2),
        size.height * (0.52 + rnd.nextDouble() * 0.22),
      );
      path.cubicTo(mid1.dx, mid1.dy, mid2.dx, mid2.dy, end.dx, end.dy);

      // underglow
      seam
        ..color = ChatKintsugiStyle.gold.withOpacity(0.16)
        ..strokeWidth = 8;
      canvas.drawPath(path, seam);

      // main seam
      seam
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ChatKintsugiStyle.gold, ChatKintsugiStyle.gold2],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..strokeWidth = 2.2;
      canvas.drawPath(path, seam);

      seam.shader = null;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


