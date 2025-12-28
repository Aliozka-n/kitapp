import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/exchange_style.dart';

/// Swap Success Dialog Widget - Takas başarılı animasyonu
class SwapSuccessDialogWidget extends StatefulWidget {
  final String bookName;
  final VoidCallback onDismiss;

  const SwapSuccessDialogWidget({
    super.key,
    required this.bookName,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required String bookName,
    required VoidCallback onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: ExchangeStyle.void_.withOpacity(0.9),
      builder: (context) => SwapSuccessDialogWidget(
        bookName: bookName,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  State<SwapSuccessDialogWidget> createState() =>
      _SwapSuccessDialogWidgetState();
}

class _SwapSuccessDialogWidgetState extends State<SwapSuccessDialogWidget>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _iconRotation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.elasticOut,
      ),
    );

    _mainController.forward();
    _particleController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Parçacık efekti
                  _buildParticles(),

                  // Ana içerik
                  ExchangeGlassPanel(
                    padding: EdgeInsets.all(32.w),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: ExchangeStyle.successGlow,
                    borderColor: ExchangeStyle.success,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Başarı ikonu
                        Transform.rotate(
                          angle: _iconRotation.value,
                          child: Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  ExchangeStyle.success,
                                  ExchangeStyle.quantum,
                                ],
                              ),
                              boxShadow: ExchangeStyle.successGlow,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 48.sp,
                              color: ExchangeStyle.void_,
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Başlık
                        Text(
                          'TAKAS TEKLİFİ GÖNDERİLDİ',
                          style: ExchangeStyle.headline(
                            fontSize: 16.sp,
                            color: ExchangeStyle.success,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 12.h),

                        // Kitap adı
                        Text(
                          '"${widget.bookName}"',
                          style: ExchangeStyle.title(
                            color: ExchangeStyle.bright,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          'kitabı için takas teklifiniz iletildi.\nKarşı tarafın yanıtını bekleyin.',
                          style: ExchangeStyle.body(
                            color: ExchangeStyle.dim,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 28.h),

                        // Tamam butonu
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onDismiss,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ExchangeStyle.success,
                              foregroundColor: ExchangeStyle.void_,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: ExchangeStyle.buttonRadius,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'TAMAM',
                              style: ExchangeStyle.label(
                                fontSize: 14.sp,
                                color: ExchangeStyle.void_,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return SizedBox(
          width: 300.w,
          height: 300.h,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(12, (index) {
              final angle = (index * 30) * math.pi / 180;
              final radius = 100.w + (math.sin(_particleController.value * 2 * math.pi + index) * 20);
              return Transform.translate(
                offset: Offset(
                  math.cos(angle + _particleController.value * 2 * math.pi) * radius,
                  math.sin(angle + _particleController.value * 2 * math.pi) * radius,
                ),
                child: Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? ExchangeStyle.success
                        : ExchangeStyle.quantum,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (index.isEven
                                ? ExchangeStyle.success
                                : ExchangeStyle.quantum)
                            .withOpacity(0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
