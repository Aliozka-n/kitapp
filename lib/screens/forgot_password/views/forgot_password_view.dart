import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base/constants/app_constants.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../common_widgets/text_field_widget.dart';
import '../../../utils/navigation_util.dart';
import '../../../utils/validators_util.dart';
import '../viewmodels/forgot_password_view_model.dart';

class ForgotPasswordView extends StatelessWidget {
  final ForgotPasswordViewModel viewModel;

  const ForgotPasswordView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => NavigationUtil.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 24),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text(
                  "Şifreni mi Unuttun?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 16.h),
                Text(
                  "E-posta adresini gir, sana şifreni sıfırlaman için bir bağlantı gönderelim.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                SizedBox(height: 48.h),
                TextFieldWidget(
                  label: "E-POSTA ADRESİ",
                  hintText: "kitapkurdu@email.com",
                  controller: viewModel.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.emailValidator,
                  prefixIcon: const Icon(Icons.alternate_email, size: 20),
                ),
                SizedBox(height: 40.h),
                ButtonWidget(
                  text: "BAĞLANTI GÖNDER",
                  isLoading: viewModel.isLoading,
                  onPressed: () async {
                    final success = await viewModel.sendResetEmail(context);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sıfırlama bağlantısı gönderildi.")),
                      );
                      NavigationUtil.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
