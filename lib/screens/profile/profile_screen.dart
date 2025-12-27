import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'profile_service.dart';
import 'viewmodels/profile_view_model.dart';
import 'views/profile_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      vmBuilder: (context) => ProfileViewModel(
        service: ProfileService(),
      ),
      builder: (context, viewModel) => ProfileView(viewModel: viewModel),
    );
  }
}
