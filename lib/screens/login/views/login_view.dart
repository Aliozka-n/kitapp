import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../utils/navigation_util.dart';
import '../../../utils/validators_util.dart';
import '../viewmodels/login_view_model.dart';

class LoginView extends StatelessWidget {
  final LoginViewModel viewModel;

  const LoginView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCanvas,
      body: Stack(
        children: [
          // Background Decorative Glows
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.1),
                    blurRadius: 100.r,
                    spreadRadius: 50.r,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            left: -50.w,
            child: Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentCyan.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withOpacity(0.05),
                    blurRadius: 80.r,
                    spreadRadius: 40.r,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h),
                    // Futuristic Mark
                    _buildFuturisticMark(),
                    SizedBox(height: 48.h),
                    // Main Title
                    Text(
                      "Geri Hoşgeldin.",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 38.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Okuma serüvenine kaldığın yerden devam et.",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: 54.h),
                    // Login Fields
                    TextFieldWidget(
                      label: "E-POSTA ADRESİ",
                      hintText: "kitapkurdu@email.com",
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.emailValidator,
                      prefixIcon: const Icon(Icons.alternate_email_rounded, size: 20),
                    ),
                    SizedBox(height: 28.h),
                    TextFieldWidget(
                      label: "ŞİFRE",
                      hintText: "••••••••",
                      controller: viewModel.passwordController,
                      obscureText: true,
                      validator: (v) => Validators.minLengthValidator(v, 6),
                      prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                    ),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => NavigationUtil.navigateToForgotPassword(context),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accentCyan,
                          textStyle: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                        child: const Text("Şifremi Unuttum"),
                      ),
                    ),
                    SizedBox(height: 36.h),
                    // Login Button
                    ButtonWidget(
                      text: "Giriş Yap",
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        final success = await viewModel.login(context);
                        if (success && context.mounted) {
                          NavigationUtil.navigateToHome(context);
                        }
                      },
                    ),
                    SizedBox(height: 48.h),
                    // Register Link
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Henüz bir hesabın yok mu?",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textSecondary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap: () => NavigationUtil.navigateToRegister(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                              ),
                              child: Text(
                                "HEMEN ÜYE OL",
                                style: GoogleFonts.outfit(
                                  color: AppColors.accentLight,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.sp,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuturisticMark() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        gradient: AppGradients.cosmic,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: AppShadows.glow,
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          color: AppColors.textWhite,
          size: 30.sp,
        ),
      ),
    );
  }
}

