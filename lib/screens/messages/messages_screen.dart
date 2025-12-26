import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/constants/app_constants.dart';
import '../../base/constants/app_size.dart';
import '../../base/views/base_view.dart';
import 'messages_service.dart';
import 'viewmodels/messages_view_model.dart';
import 'views/messages_view.dart';

/// Messages Screen - Modern mesaj listesi ekranı
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildModernAppBar(context),
              Expanded(
                child: BaseView<MessagesViewModel>(
                  vmBuilder: (_) => MessagesViewModel(
                    service: MessagesService(),
                  ),
                  builder: (context, viewModel) => MessagesView(viewModel: viewModel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.sizeLarge.w,
        vertical: AppSizes.sizeLarge.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          Text(
            'Mesajlar',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
                size: 24.sp,
              ),
              onPressed: () {
                // TODO: Open new message dialog
              },
            ),
          ),
        ],
      ),
    );
  }
}

