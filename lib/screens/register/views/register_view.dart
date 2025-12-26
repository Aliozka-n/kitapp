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
import '../viewmodels/register_view_model.dart';
import '../../../common_widgets/alert_dialog_widget.dart';

/// Register View - Modern and minimalist registration screen
class RegisterView extends StatelessWidget {
  final RegisterViewModel viewModel;

  const RegisterView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTexts.createAccount,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: AppColors.backgroundLight,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppEdgeInsets.symmetric(horizontal: AppSizes.sizeXLarge),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Username Field
                    TextFieldWidget(
                      textTitle: AppTexts.username,
                      textController: viewModel.nameController,
                      validator: Validators.emptyFieldValidator,
                      textIcon: Icons.person_outline,
                      hintText: 'Kullanıcı adınız',
                    ),
                    
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Email Field
                    TextFieldWidget(
                      textTitle: AppTexts.email,
                      textController: viewModel.emailController,
                      validator: Validators.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      textIcon: Icons.email_outlined,
                      hintText: 'ornek@email.com',
                    ),
                    
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Password Field
                    TextFieldWidget(
                      textTitle: AppTexts.password,
                      textController: viewModel.passwordController,
                      validator: (value) => Validators.minLengthValidator(value, 6),
                      obscureText: true,
                      textIcon: Icons.lock_outline,
                      hintText: 'En az 6 karakter',
                    ),
                    
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Confirm Password Field
                    TextFieldWidget(
                      textTitle: AppTexts.passwordConfirmation,
                      textController: viewModel.confirmPasswordController,
                      validator: (value) => Validators.repeatPasswordValidator(
                        value,
                        viewModel.passwordController.text,
                      ),
                      obscureText: true,
                      textIcon: Icons.lock_outline,
                      hintText: 'Şifrenizi tekrar girin',
                    ),
                    
                    SizedBox(height: AppSizes.sizeXLarge.h),
                    
                    // Register Button
                    ButtonWidget(
                      textTitle: AppTexts.createAccount,
                      onTap: () => _handleRegister(context),
                      enabled: !viewModel.isLoading && viewModel.acceptedTerms,
                      isLoading: viewModel.isLoading,
                    ),
                    
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppTexts.alreadyHaveAccount,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            AppTexts.login,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: AppSizes.sizeLarge.h),
                    
                    // Error Message
                    if (viewModel.errorMessage != null)
                      Container(
                        padding: AppEdgeInsets.all(AppSizes.sizeMedium),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(AppSizes.sizeMedium.w),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.errorColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: AppSizes.sizeSmall.w),
                            Expanded(
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: AppColors.errorColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context) async {
    if (!viewModel.acceptedTerms) {
      AlertDialogWidget.showErrorDialog(
        context,
        'Lütfen kullanım koşullarını kabul edin',
      );
      return;
    }

    final success = await viewModel.register(context);
    
    if (success && context.mounted) {
      await AlertDialogWidget.showSuccessfulDialog(
        context,
        'Kayıt başarılı! Hoş geldiniz.',
      );
      
      if (context.mounted) {
        // Navigate to home screen
        NavigationUtil.navigateAndRemoveUntil(
          context,
          NavigationUtil.homeScreen,
        );
      }
    } else if (context.mounted && viewModel.errorMessage != null) {
      // Error already shown in viewModel
    }
  }
}
