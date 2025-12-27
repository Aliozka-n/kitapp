import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../constants/app_size.dart';

/// Loading Widget - Distinctive Brutalist Loading Indicator
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
          Stack(
            alignment: Alignment.center,
            children: [
              // Shadow/Offset frame
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
              // Spinning element
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                curve: Curves.linear,
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 2 * 3.14159,
                    child: Container(
                      width: size * 0.6,
                      height: size * 0.6,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                      ),
                    ),
                  );
                },
                onEnd:
                    () {}, // Handled by repetition if we used a controller, but for simplicity:
              ),
              // Just use a simple spinning container for a distinctive feel
              _SpinningSquare(size: size, color: color),
            ],
          ),
          if (message != null) ...[
            SizedBox(height: AppSizes.sizeLarge.h),
            Text(
              message!.toUpperCase(),
              style: GoogleFonts.syne(
                color: AppColors.textPrimary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SpinningSquare extends StatefulWidget {
  final double size;
  final Color? color;

  const _SpinningSquare({required this.size, this.color});

  @override
  State<_SpinningSquare> createState() => _SpinningSquareState();
}

class _SpinningSquareState extends State<_SpinningSquare>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: widget.size * 0.4,
        height: widget.size * 0.4,
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.accent,
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
