import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Exchange Style - Quantum Book Exchange Aesthetic
/// 
/// Koyu uzay teması, cyan/amber aksan renkler, kitap takas animasyonları
class ExchangeStyle {
  ExchangeStyle._();

  // ═══════════════════════════════════════════════════════════════════
  // COLOR PALETTE - "Quantum Swap" Theme
  // ═══════════════════════════════════════════════════════════════════
  
  /// Derin uzay karanlığı - ana arka plan
  static const Color void_ = Color(0xFF0A0E14);
  
  /// Yıldız tozu - hafif arka plan
  static const Color stardust = Color(0xFF121820);
  
  /// Nebula - kart arka planı
  static const Color nebula = Color(0xFF1A222D);
  
  /// Cyan ışık - aksan renk
  static const Color quantum = Color(0xFF00D4FF);
  
  /// Amber ışık - ikincil aksan
  static const Color amber = Color(0xFFFFB400);
  
  /// Başarı yeşili
  static const Color success = Color(0xFF00E676);
  
  /// Hata kırmızısı
  static const Color error = Color(0xFFFF5252);
  
  /// Bekleme turuncusu
  static const Color pending = Color(0xFFFF9100);
  
  /// Soluk metin
  static const Color dim = Color(0xFF4A5568);
  
  /// Normal metin
  static const Color text = Color(0xFFE2E8F0);
  
  /// Parlak metin
  static const Color bright = Color(0xFFF7FAFC);

  // ═══════════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════════
  
  /// Ana arka plan gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [void_, stardust, void_],
    stops: [0.0, 0.5, 1.0],
  );
  
  /// Swap kartı gradient (sol kitap - teklif eden)
  static LinearGradient get offeredCardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      quantum.withOpacity(0.15),
      quantum.withOpacity(0.05),
    ],
  );
  
  /// Swap kartı gradient (sağ kitap - istenen)
  static LinearGradient get requestedCardGradient => LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      amber.withOpacity(0.15),
      amber.withOpacity(0.05),
    ],
  );

  // ═══════════════════════════════════════════════════════════════════
  // SHADOWS & GLOWS
  // ═══════════════════════════════════════════════════════════════════
  
  static List<BoxShadow> get quantumGlow => [
    BoxShadow(
      color: quantum.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get amberGlow => [
    BoxShadow(
      color: amber.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get successGlow => [
    BoxShadow(
      color: success.withOpacity(0.4),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════
  // TYPOGRAPHY - "Orbitron" style monospace feel
  // ═══════════════════════════════════════════════════════════════════
  
  static TextStyle headline({double? fontSize, Color? color}) => TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: fontSize ?? 24.sp,
    fontWeight: FontWeight.w700,
    color: color ?? bright,
    letterSpacing: 2.0,
  );
  
  static TextStyle title({double? fontSize, Color? color}) => TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: fontSize ?? 18.sp,
    fontWeight: FontWeight.w600,
    color: color ?? text,
    letterSpacing: 1.0,
  );
  
  static TextStyle body({double? fontSize, Color? color}) => TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: fontSize ?? 14.sp,
    fontWeight: FontWeight.w400,
    color: color ?? text,
    height: 1.5,
  );
  
  static TextStyle label({double? fontSize, Color? color}) => TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: fontSize ?? 11.sp,
    fontWeight: FontWeight.w500,
    color: color ?? dim,
    letterSpacing: 1.5,
  );
  
  static TextStyle bookTitle({double? fontSize, Color? color}) => TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: fontSize ?? 15.sp,
    fontWeight: FontWeight.w600,
    color: color ?? bright,
    letterSpacing: 0.5,
  );
  
  static TextStyle bookAuthor({double? fontSize, Color? color}) => TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: fontSize ?? 12.sp,
    fontWeight: FontWeight.w400,
    color: color ?? dim,
    fontStyle: FontStyle.italic,
  );

  // ═══════════════════════════════════════════════════════════════════
  // BORDERS & RADIUS
  // ═══════════════════════════════════════════════════════════════════
  
  static BorderRadius get cardRadius => BorderRadius.circular(16.r);
  static BorderRadius get buttonRadius => BorderRadius.circular(12.r);
  static BorderRadius get chipRadius => BorderRadius.circular(8.r);
  
  static Border quantumBorder([double width = 1.0]) => Border.all(
    color: quantum.withOpacity(0.4),
    width: width,
  );
  
  static Border amberBorder([double width = 1.0]) => Border.all(
    color: amber.withOpacity(0.4),
    width: width,
  );

  // ═══════════════════════════════════════════════════════════════════
  // DURATIONS
  // ═══════════════════════════════════════════════════════════════════
  
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration dramatic = Duration(milliseconds: 1200);
}

// ═══════════════════════════════════════════════════════════════════
// GLASS PANEL WIDGET
// ═══════════════════════════════════════════════════════════════════

class ExchangeGlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? borderColor;
  final Gradient? gradient;

  const ExchangeGlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.boxShadow,
    this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? ExchangeStyle.cardRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: gradient ?? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ExchangeStyle.nebula.withOpacity(0.8),
                ExchangeStyle.stardust.withOpacity(0.6),
              ],
            ),
            borderRadius: borderRadius ?? ExchangeStyle.cardRadius,
            border: Border.all(
              color: borderColor ?? ExchangeStyle.quantum.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: boxShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// ANIMATED BACKGROUND
// ═══════════════════════════════════════════════════════════════════

class ExchangeBackground extends StatelessWidget {
  final Widget child;

  const ExchangeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: ExchangeStyle.backgroundGradient,
      ),
      child: Stack(
        children: [
          // Subtle grid pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPatternPainter(),
            ),
          ),
          // Quantum glow orbs
          Positioned(
            top: -100.h,
            left: -50.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ExchangeStyle.quantum.withOpacity(0.08),
                    ExchangeStyle.quantum.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80.h,
            right: -60.w,
            child: Container(
              width: 280.w,
              height: 280.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ExchangeStyle.amber.withOpacity(0.06),
                    ExchangeStyle.amber.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ExchangeStyle.quantum.withOpacity(0.03)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
