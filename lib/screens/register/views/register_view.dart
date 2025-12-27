import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../utils/navigation_util.dart';
import '../../../utils/validators_util.dart';
import '../viewmodels/register_view_model.dart';

class RegisterView extends StatelessWidget {
  final RegisterViewModel viewModel;

  const RegisterView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                IconButton(
                  onPressed: () => NavigationUtil.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(height: 24.h),
                Text(
                  "Yeni Bir Başlangıç.",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 36.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Kendi kütüphaneni oluşturmaya başla.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 40.h),
                TextFieldWidget(
                  label: "AD SOYAD",
                  hintText: "Ali Yılmaz",
                  controller: viewModel.nameController,
                  validator: Validators.emptyFieldValidator,
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                ),
                SizedBox(height: 20.h),
                TextFieldWidget(
                  label: "E-POSTA ADRESİ",
                  hintText: "kitapkurdu@email.com",
                  controller: viewModel.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.emailValidator,
                  prefixIcon: const Icon(Icons.alternate_email, size: 20),
                ),
                SizedBox(height: 20.h),
                TextFieldWidget(
                  label: "ŞİFRE",
                  hintText: "••••••••",
                  controller: viewModel.passwordController,
                  obscureText: true,
                  validator: (v) => Validators.minLengthValidator(v, 6),
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                ),
                SizedBox(height: 20.h),
                TextFieldWidget(
                  label: "ŞİFRE TEKRAR",
                  hintText: "••••••••",
                  controller: viewModel.confirmPasswordController,
                  obscureText: true,
                  validator: (v) => Validators.repeatPasswordValidator(
                    v,
                    viewModel.passwordController.text,
                  ),
                  prefixIcon: const Icon(Icons.lock_reset, size: 20),
                ),
                SizedBox(height: 32.h),
                ButtonWidget(
                  text: "KAYIT OL",
                  isLoading: viewModel.isLoading,
                  onPressed: () async {
                    final success = await viewModel.register(context);
                    if (success && context.mounted) {
                      NavigationUtil.navigateToHome(context);
                    }
                  },
                ),
                SizedBox(height: 32.h),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Zaten bir hesabın var mı?",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () => NavigationUtil.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                          ),
                          child: Text(
                            "GİRİŞ YAP",
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
    );
  }
}
