import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/navigation_util.dart';

/// Swap Start Bottom Sheet Widget - Takas başlatma onay ekranı
/// 
/// Exchange ekranına yönlendirmeden önce onay ister
class SwapStartBottomSheetWidget extends StatelessWidget {
  final String receiverId;
  final String receiverName;

  const SwapStartBottomSheetWidget({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String receiverId,
    required String receiverName,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SwapStartBottomSheetWidget(
        receiverId: receiverId,
        receiverName: receiverName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _SwapColors.surface,
                _SwapColors.surface.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(
              color: _SwapColors.cyan.withValues(alpha: 0.2),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: _SwapColors.dim,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // İkon animasyonu
                  _buildAnimatedIcon(),
                  SizedBox(height: 20.h),

                  // Başlık
                  Text(
                    'QUANTUM TAKAS',
                    style: TextStyle(
                      fontFamily: 'SpaceMono',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: _SwapColors.cyan,
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Alt başlık
                  Text(
                    '$receiverName ile takas başlat',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: _SwapColors.bright,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Açıklama
                  Text(
                    'Kendi kitaplarınızdan birini karşı tarafın\nkitaplarından biriyle değiştirin',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _SwapColors.dim,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 28.h),

                  // Özellikler
                  _buildFeatureRow(
                    icon: Icons.auto_awesome,
                    text: 'Her iki taraftan da kitap seçin',
                    color: _SwapColors.cyan,
                  ),
                  SizedBox(height: 12.h),
                  _buildFeatureRow(
                    icon: Icons.message_outlined,
                    text: 'Teklifinize mesaj ekleyin',
                    color: _SwapColors.amber,
                  ),
                  SizedBox(height: 12.h),
                  _buildFeatureRow(
                    icon: Icons.handshake_outlined,
                    text: 'Karşı tarafın onayını bekleyin',
                    color: _SwapColors.success,
                  ),
                  SizedBox(height: 32.h),

                  // Butonlar
                  Row(
                    children: [
                      // İptal butonu
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context, false),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              color: _SwapColors.cardBg,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: _SwapColors.dim.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'İptal',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _SwapColors.dim,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Başlat butonu
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                            NavigationUtil.navigateToExchange(
                              context,
                              otherUserId: receiverId,
                              otherUserName: receiverName,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _SwapColors.cyan,
                                  _SwapColors.cyan.withValues(alpha: 0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: _SwapColors.cyan.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.swap_horiz_rounded,
                                  size: 20.sp,
                                  color: _SwapColors.surface,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Takas Başlat',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _SwapColors.surface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _SwapColors.cyan,
                  _SwapColors.amber,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _SwapColors.cyan.withValues(alpha: 0.4),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Icon(
              Icons.swap_horiz_rounded,
              size: 36.sp,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            icon,
            size: 18.sp,
            color: color,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: _SwapColors.text,
            ),
          ),
        ),
      ],
    );
  }
}

/// Swap Sheet Colors
class _SwapColors {
  static const Color surface = Color(0xFF0A0E14);
  static const Color cardBg = Color(0xFF1A202C);
  static const Color cyan = Color(0xFF00D4FF);
  static const Color amber = Color(0xFFFFB400);
  static const Color success = Color(0xFF48BB78);
  static const Color dim = Color(0xFF718096);
  static const Color text = Color(0xFFCBD5E0);
  static const Color bright = Color(0xFFF7FAFC);
}
