import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'login_service.dart';
import 'viewmodels/login_view_model.dart';
import 'views/login_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      vmBuilder: (_) => LoginViewModel(
        service: LoginService(),
      ),
      builder: (context, viewModel) => LoginView(viewModel: viewModel),
    );
  }
}
