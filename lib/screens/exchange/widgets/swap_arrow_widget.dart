import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/exchange_style.dart';

/// Swap Arrow Widget - İki kitap arasındaki takas animasyonu
/// 
/// Quantum transfer efekti ile birlikte dönen ok animasyonu
class SwapArrowWidget extends StatefulWidget {
  final bool isActive;
  final VoidCallback? onTap;

  const SwapArrowWidget({
    super.key,
    this.isActive = false,
    this.onTap,
  });

  @override
  State<SwapArrowWidget> createState() => _SwapArrowWidgetState();
}

class _SwapArrowWidgetState extends State<SwapArrowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SwapArrowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 80.w,
        height: 80.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Arka plan halka - quantum ring
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: widget.isActive ? _rotationAnimation.value : 0,
                  child: Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isActive
                            ? ExchangeStyle.quantum.withOpacity(0.6)
                            : ExchangeStyle.dim.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: widget.isActive
                          ? [
                              BoxShadow(
                                color: ExchangeStyle.quantum.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: CustomPaint(
                      painter: _DashedCirclePainter(
                        color: widget.isActive
                            ? ExchangeStyle.amber
                            : ExchangeStyle.dim.withOpacity(0.2),
                        dashWidth: 8,
                        dashSpace: 6,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Merkez ikon
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isActive ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isActive
                            ? [
                                ExchangeStyle.quantum,
                                ExchangeStyle.amber,
                              ]
                            : [
                                ExchangeStyle.nebula,
                                ExchangeStyle.stardust,
                              ],
                      ),
                      boxShadow: widget.isActive
                          ? [
                              BoxShadow(
                                color: ExchangeStyle.quantum.withOpacity(0.4),
                                blurRadius: 12,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.swap_horiz_rounded,
                      color: widget.isActive
                          ? ExchangeStyle.void_
                          : ExchangeStyle.dim,
                      size: 28.sp,
                    ),
                  ),
                );
              },
            ),

            // Parçacıklar (aktif olduğunda)
            if (widget.isActive)
              ...List.generate(6, (index) {
                final angle = (index * 60) * math.pi / 180;
                return AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    final adjustedAngle = angle + _rotationAnimation.value;
                    return Transform.translate(
                      offset: Offset(
                        math.cos(adjustedAngle) * 45.w,
                        math.sin(adjustedAngle) * 45.h,
                      ),
                      child: Container(
                        width: 4.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: index.isEven
                              ? ExchangeStyle.quantum
                              : ExchangeStyle.amber,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (index.isEven
                                      ? ExchangeStyle.quantum
                                      : ExchangeStyle.amber)
                                  .withOpacity(0.6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  _DashedCirclePainter({
    required this.color,
    this.dashWidth = 5,
    this.dashSpace = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final radius = (size.width / 2) - 5;
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (var i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashWidth + dashSpace) / radius);
      final sweepAngle = dashWidth / radius;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
