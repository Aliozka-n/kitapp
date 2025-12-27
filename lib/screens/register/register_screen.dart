import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'register_service.dart';
import 'viewmodels/register_view_model.dart';
import 'views/register_view.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
      vmBuilder: (_) => RegisterViewModel(service: RegisterService()),
      builder: (context, viewModel) => RegisterView(viewModel: viewModel),
    );
  }
}
