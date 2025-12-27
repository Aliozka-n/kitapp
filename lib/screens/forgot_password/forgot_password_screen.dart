import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'forgot_password_service.dart';
import 'viewmodels/forgot_password_view_model.dart';
import 'views/forgot_password_view.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordViewModel>(
      vmBuilder: (_) => ForgotPasswordViewModel(service: ForgotPasswordService()),
      builder: (context, viewModel) => ForgotPasswordView(viewModel: viewModel),
    );
  }
}
