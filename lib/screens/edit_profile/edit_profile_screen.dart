import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import '../../common_widgets/alert_dialog_widget.dart';
import 'edit_profile_service.dart';
import 'viewmodels/edit_profile_view_model.dart';
import 'views/edit_profile_view.dart';

/// Edit Profile Screen - Profil düzenleme ekranı
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileViewModel>(
      vmBuilder: (_) {
        _viewModel = EditProfileViewModel(service: EditProfileService());
        return _viewModel!;
      },
      builder: (context, viewModel) => PopScope(
        canPop: !viewModel.isFormChanged,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          
          if (viewModel.isFormChanged) {
            final shouldPop = await AlertDialogWidget.showConfirmationDialog(
              context,
              'Değişiklikleri kaydetmeden çıkmak istediğinize emin misiniz?',
              confirmText: 'Çık',
              cancelText: 'İptal',
            );
            
            if (shouldPop && context.mounted) {
              Navigator.pop(context);
            }
          }
        },
        child: EditProfileView(viewModel: viewModel),
      ),
    );
  }
}

