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
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                // Decorative Element: "The Inkwell" Logo/Mark
                _buildLogo(),
                SizedBox(height: 40.h),
                // Main Title
                Text(
                  "Geri Hoşgeldin.",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 8.h),
                Text(
                  "Okuma serüvenine kaldığın yerden devam et.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                SizedBox(height: 48.h),
                // Login Fields
                TextFieldWidget(
                  label: "E-POSTA ADRESİ",
                  hintText: "kitapkurdu@email.com",
                  controller: viewModel.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.emailValidator,
                  prefixIcon: const Icon(Icons.alternate_email, size: 20),
                ),
                SizedBox(height: 24.h),
                TextFieldWidget(
                  label: "ŞİFRE",
                  hintText: "••••••••",
                  controller: viewModel.passwordController,
                  obscureText: true,
                  validator: (v) => Validators.minLengthValidator(v, 6),
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                ),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => NavigationUtil.navigateToForgotPassword(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: GoogleFonts.syne(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                      ),
                    ),
                    child: const Text("ŞİFREMİ UNUTTUM"),
                  ),
                ),
                SizedBox(height: 32.h),
                // Login Button
                ButtonWidget(
                  text: "GİRİŞ YAP",
                  isLoading: viewModel.isLoading,
                  onPressed: () async {
                    final success = await viewModel.login(context);
                    if (success && context.mounted) {
                      NavigationUtil.navigateToHome(context);
                    }
                  },
                ),
                SizedBox(height: 40.h),
                // Register Link
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Henüz bir hesabın yok mu?",
                        style: GoogleFonts.instrumentSans(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap: () => NavigationUtil.navigateToRegister(context),
                        child: Text(
                          "HEMEN ÜYE OL",
                          style: GoogleFonts.syne(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w800,
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
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
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 30,
              height: 30,
              color: AppColors.accent,
            ),
          ),
          const Center(
            child: Icon(
              Icons.menu_book_rounded,
              color: AppColors.textWhite,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
