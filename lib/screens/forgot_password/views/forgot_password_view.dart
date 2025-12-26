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
import '../../../common_widgets/alert_dialog_widget.dart';
import '../viewmodels/forgot_password_view_model.dart';

/// Forgot Password View - Şifre sıfırlama ekranı
class ForgotPasswordView extends StatelessWidget {
  final ForgotPasswordViewModel viewModel;

  const ForgotPasswordView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTexts.forgotPassword,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppEdgeInsets.symmetric(horizontal: AppSizes.sizeXLarge),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSizes.sizeXXLarge.h * 2),

                    // Header
                    _buildHeader(context),

                    SizedBox(height: AppSizes.sizeXXLarge.h * 2),

                    // Email Field
                    TextFieldWidget(
                      textTitle: AppTexts.email,
                      textController: viewModel.emailController,
                      validator: Validators.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      textIcon: Icons.email_outlined,
                      hintText: 'ornek@email.com',
                    ),

                    SizedBox(height: AppSizes.sizeXLarge.h),

                    // Send Reset Email Button
                    ButtonWidget(
                      textTitle: 'Şifre Sıfırlama E-postası Gönder',
                      onTap: () => _handleSendResetEmail(context),
                      enabled: !viewModel.isLoading,
                      isLoading: viewModel.isLoading,
                    ),

                    SizedBox(height: AppSizes.sizeLarge.h),

                    // Back to Login Button
                    ButtonWidget(
                      textTitle: 'Giriş Ekranına Dön',
                      onTap: () {
                        NavigationUtil.goBack(context);
                      },
                      isOutlined: true,
                      color: AppColors.primary,
                      textColor: AppColors.primary,
                    ),

                    SizedBox(height: AppSizes.sizeLarge.h),

                    // Error Message
                    if (viewModel.errorMessage != null)
                      Container(
                        padding: AppEdgeInsets.all(AppSizes.sizeMedium),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius:
                              BorderRadius.circular(AppSizes.sizeMedium.w),
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Icon
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppShadows.buttonShadow,
          ),
          child: Icon(
            Icons.lock_reset,
            color: AppColors.textWhite,
            size: 40.sp,
          ),
        ),

        SizedBox(height: AppSizes.sizeXLarge.h),

        // Title
        Text(
          'Şifremi Unuttum',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: AppSizes.sizeSmall.h),

        // Subtitle
        Text(
          'E-posta adresinize şifre sıfırlama bağlantısı göndereceğiz',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Future<void> _handleSendResetEmail(BuildContext context) async {
    final success = await viewModel.sendResetEmail(context);

    if (success && context.mounted) {
      await AlertDialogWidget.showSuccessfulDialog(
        context,
        'Şifre sıfırlama e-postası gönderildi. Lütfen e-posta kutunuzu kontrol edin.',
      );

      if (context.mounted) {
        NavigationUtil.goBack(context);
      }
    }
  }
}

