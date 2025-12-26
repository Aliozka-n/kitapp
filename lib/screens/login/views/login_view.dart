import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base/constants/app_constants.dart';
import '../../../base/constants/app_size.dart';
import '../../../base/constants/app_edge_insets.dart';
import '../../../base/constants/app_texts.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../utils/validators_util.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/login_view_model.dart';

/// Login View - Editorial & Refined Design
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
      body: Stack(
        children: [
          // Background Decor - Subtle Geometric Shapes
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 100.h,
            left: -50.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.03),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: AppEdgeInsets.symmetric(horizontal: AppSizes.sizeXLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Editorial Left Align
                children: [
                  SizedBox(height: 80.h),
                  
                  // Editorial Header
                  _buildHeader(context),

                  SizedBox(height: 60.h),

                  // Form Section
                  Form(
                    key: viewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email
                        Text(
                          AppTexts.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFieldWidget(
                          textTitle: "", // Label is above
                          textController: viewModel.emailController,
                          validator: Validators.emailValidator,
                          keyboardType: TextInputType.emailAddress,
                          textIcon: Icons.alternate_email,
                          hintText: 'hello@kitapp.com',
                        ),

                        SizedBox(height: 24.h),

                        // Password
                        Text(
                          AppTexts.password,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFieldWidget(
                          textTitle: "",
                          textController: viewModel.passwordController,
                          validator: (value) => Validators.minLengthValidator(value, 6),
                          obscureText: true,
                          textIcon: Icons.lock_outline_rounded,
                          hintText: '••••••••',
                        ),

                        SizedBox(height: 16.h),

                        // Helper Links
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24.h,
                                  width: 24.w,
                                  child: Checkbox(
                                    value: viewModel.rememberMe,
                                    onChanged: (value) {
                                      viewModel.setRememberMe(value ?? false);
                                    },
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    side: BorderSide(color: AppColors.grey),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  AppTexts.rememberMe,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                NavigationUtil.navigateToPage(
                                  context,
                                  NavigationUtil.forgotPasswordScreen,
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                AppTexts.forgotPassword,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 40.h),

                        // Login Button
                        ButtonWidget(
                          textTitle: AppTexts.login,
                          onTap: () => _handleLogin(context),
                          enabled: !viewModel.isLoading,
                          isLoading: viewModel.isLoading,
                          color: AppColors.primary,
                          textColor: AppColors.textWhite,
                        ),

                        SizedBox(height: 24.h),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.divider)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                "veya",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.divider)),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // Register Link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              NavigationUtil.navigateToPage(
                                context,
                                NavigationUtil.registerScreen,
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Hesabın yok mu? ",
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: AppTexts.register,
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Error Message
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.errorColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.errorColor, size: 20.sp),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: AppColors.errorColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.auto_stories,
          size: 48.sp,
          color: AppColors.primary,
        ),
        SizedBox(height: 24.h),
        Text(
          AppTexts.appName,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(height: 8.h),
        Text(
          AppTexts.loginToAccount,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final success = await viewModel.login(context);

    if (success && context.mounted) {
      NavigationUtil.navigateAndRemoveUntil(
        context,
        NavigationUtil.homeScreen,
      );
    }
  }
}
