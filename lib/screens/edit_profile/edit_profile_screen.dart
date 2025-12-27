import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'edit_profile_service.dart';
import 'viewmodels/edit_profile_view_model.dart';
import 'views/edit_profile_view.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileViewModel>(
      vmBuilder: (_) => EditProfileViewModel(service: EditProfileService()),
      builder: (context, viewModel) => EditProfileView(viewModel: viewModel),
    );
  }
}
