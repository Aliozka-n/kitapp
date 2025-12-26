import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import '../../common_widgets/alert_dialog_widget.dart';
import 'forgot_password_service.dart';
import 'viewmodels/forgot_password_view_model.dart';
import 'views/forgot_password_view.dart';

/// Forgot Password Screen - Şifre sıfırlama ekranı
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordViewModel>(
      vmBuilder: (_) {
        _viewModel = ForgotPasswordViewModel(service: ForgotPasswordService());
        return _viewModel!;
      },
      builder: (context, viewModel) => PopScope(
        canPop: viewModel.isFormEmpty,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          
          if (!viewModel.isFormEmpty) {
            final shouldPop = await AlertDialogWidget.showConfirmationDialog(
              context,
              'Sayfadan çıkmak istediğinize emin misiniz? Girilen bilgiler kaybolacak.',
              confirmText: 'Çık',
              cancelText: 'İptal',
            );
            
            if (shouldPop && context.mounted) {
              Navigator.pop(context);
            }
          }
        },
        child: ForgotPasswordView(viewModel: viewModel),
      ),
    );
  }
}

