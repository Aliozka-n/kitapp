import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../constants/app_size.dart';

/// Loading Widget - Ethereal Glowing Loader
class LoadingWidget extends StatelessWidget {
  final double size;
  final String? message;
  final Color? color;

  const LoadingWidget({
    Key? key,
    this.size = 60.0,
    this.message,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FuturisticSpinner(size: size, color: color),
          if (message != null) ...[
            SizedBox(height: AppSizes.sizeLarge.h),
            Text(
              message!,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FuturisticSpinner extends StatefulWidget {
  final double size;
  final Color? color;

  const _FuturisticSpinner({required this.size, this.color});

  @override
  State<_FuturisticSpinner> createState() => _FuturisticSpinnerState();
}

class _FuturisticSpinnerState extends State<_FuturisticSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glow
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (widget.color ?? AppColors.accent).withOpacity(0.2),
                      blurRadius: 20.r,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              // Rotating Ring
              RotationTransition(
                turns: _controller,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _SpinnerPainter(
                    color: widget.color ?? AppColors.accent,
                    secondaryColor: AppColors.accentCyan,
                  ),
                ),
              ),
              // Center Dot
              Container(
                width: widget.size * 0.15,
                height: widget.size * 0.15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color ?? AppColors.accentCyan,
                  boxShadow: [
                    BoxShadow(
                      color: (widget.color ?? AppColors.accentCyan).withOpacity(0.6),
                      blurRadius: 10.r,
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final Color color;
  final Color secondaryColor;

  _SpinnerPainter({required this.color, required this.secondaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 3.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Gradient Sweep
    final rect = Rect.fromCircle(center: center, radius: radius);
    paint.shader = SweepGradient(
      colors: [
        color.withOpacity(0),
        color.withOpacity(0.5),
        secondaryColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);

    canvas.drawArc(
      rect,
      0,
      4.7, // ~270 degrees
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

