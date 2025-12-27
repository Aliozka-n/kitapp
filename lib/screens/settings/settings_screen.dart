import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'settings_service.dart';
import 'viewmodels/settings_view_model.dart';
import 'views/settings_view.dart';

/// Settings Screen - Ayarlar ekranı wrapper
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsViewModel>(
      vmBuilder: (_) => SettingsViewModel(
        service: SettingsService(),
      ),
      builder: (context, viewModel) => SettingsView(viewModel: viewModel),
    );
  }
}
