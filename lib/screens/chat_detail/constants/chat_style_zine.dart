import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// ChatDetail v4: "Brutalist Zine / Newsprint Collage"
/// Newsprint paper + harsh black rules + red stamp accent.
class ChatZineStyle {
  ChatZineStyle._();

  static const Color paper = Color(0xFFF7F0E6);
  static const Color paper2 = Color(0xFFF1E7D9);
  static const Color ink = Color(0xFF12110F);
  static const Color inkSoft = Color(0xFF2A2723);
  static const Color dim = Color(0xFF6C6760);
  static const Color red = Color(0xFFE01E37);
  static const Color tape = Color(0xFFE9DDC9);
  static const Color border = ink;
  static const Color danger = Color(0xFFB00020);

  static LinearGradient get bg => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [paper, paper2],
      );

  static TextStyle headline(double size) => GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: FontWeight.w800,
        height: 1.0,
        color: ink,
        letterSpacing: -0.4,
      );

  static TextStyle labelMono(double size, {Color? color}) =>
      GoogleFonts.ibmPlexMono(
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1.0,
        color: color ?? dim,
        letterSpacing: 0.6,
      );

  static TextStyle body(double size, {Color? color}) => GoogleFonts.instrumentSans(
        fontSize: size,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: color ?? inkSoft,
      );

  static List<BoxShadow> get brutalShadow => [
        BoxShadow(
          color: ink.withOpacity(0.12),
          blurRadius: 0,
          offset: Offset(6.w, 6.h),
        ),
      ];
}

/// Background: paper gradient + halftone dots + collage tape strips.
class ChatZineBackground extends StatelessWidget {
  final Widget child;

  const ChatZineBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(decoration: BoxDecoration(gradient: ChatZineStyle.bg)),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _ZinePainter()),
          ),
        ),
        child,
      ],
    );
  }
}

class _ZinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(23);

    // Halftone dots (sparser)
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 420; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final r = 0.6 + rnd.nextDouble() * 0.9;
      dotPaint.color = ChatZineStyle.ink.withOpacity(0.02 + rnd.nextDouble() * 0.04);
      canvas.drawCircle(Offset(x, y), r, dotPaint);
    }

    // Tape strips
    final tapePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = ChatZineStyle.tape.withOpacity(0.65);
    final tapeBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ChatZineStyle.ink.withOpacity(0.12);

    final strips = <Rect>[
      Rect.fromLTWH(-20, size.height * 0.18, size.width * 0.55, 36),
      Rect.fromLTWH(size.width * 0.62, size.height * 0.08, size.width * 0.46, 32),
      Rect.fromLTWH(size.width * 0.15, size.height * 0.78, size.width * 0.70, 38),
    ];

    for (final r in strips) {
      final path = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            r,
            const Radius.circular(10),
          ),
        );
      canvas.save();
      canvas.translate(r.center.dx, r.center.dy);
      canvas.rotate((rnd.nextDouble() - 0.5) * 0.10);
      canvas.translate(-r.center.dx, -r.center.dy);
      canvas.drawPath(path, tapePaint);
      canvas.drawPath(path, tapeBorder);
      canvas.restore();
    }

    // Red stamp block
    final stamp = Paint()..color = ChatZineStyle.red.withOpacity(0.10);
    final stampBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = ChatZineStyle.red.withOpacity(0.35);

    final stampRect = Rect.fromLTWH(size.width * 0.08, size.height * 0.02, 120, 52);
    canvas.drawRRect(
      RRect.fromRectAndRadius(stampRect, const Radius.circular(14)),
      stamp,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(stampRect, const Radius.circular(14)),
      stampBorder,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


