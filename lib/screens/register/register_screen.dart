import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import '../../common_widgets/alert_dialog_widget.dart';
import 'register_service.dart';
import 'viewmodels/register_view_model.dart';
import 'views/register_view.dart';

/// Register Screen - StatefulWidget wrapper
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
      vmBuilder: (_) {
        _viewModel = RegisterViewModel(service: RegisterService());
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
        child: RegisterView(viewModel: viewModel),
      ),
    );
  }
}
