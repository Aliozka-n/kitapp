import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../viewmodels/base_view_model.dart';
import '../common_widgets/loading_widget.dart';

/// Base View sınıfı - Tüm ekranlar bu sınıfı kullanmalıdır
class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final T Function(BuildContext)? vmBuilder; // ViewModel oluşturucu
  final Widget Function(BuildContext, T)? builder; // UI builder
  final bool useValue; // Existing ViewModel kullan

  const BaseView({
    Key? key,
    required this.vmBuilder,
    required this.builder,
    this.useValue = false,
  })  : assert(vmBuilder != null, builder != null),
        super(key: key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  @override
  Widget build(BuildContext context) {
    if (widget.vmBuilder == null || widget.builder == null) {
      return const SizedBox.shrink();
    }
    return widget.useValue
        ? ChangeNotifierProvider<T>.value(
            value: widget.vmBuilder!(context),
            child: Consumer<T>(builder: _buildScreenContent),
          )
        : ChangeNotifierProvider<T>(
            create: (context) => widget.vmBuilder!(context),
            child: Consumer<T>(builder: _buildScreenContent),
          );
  }

  Widget _buildScreenContent(BuildContext context, T viewModel, Widget? child) {
    // İlk yükleniyorsa loading göster
    if (!viewModel.isInitialized) {
      return Container(
        decoration: BoxDecoration(
          gradient: AppGradients.obsidian,
        ),
        child: LoadingWidget(
          size: 70.h,
          message: 'Yükleniyor...',
        ),
      );
    }

    // UI'ı göster, eğer loading varsa overlay loading ekle
    Widget content;
    try {
      if (widget.builder != null) {
        content = widget.builder!(context, viewModel);
      } else {
        content = const SizedBox.shrink();
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('BaseView builder error - ${viewModel.runtimeType}: $e');
        print('Stack trace: $stackTrace');
      }
      content = Center(
        child: Text(
          'Bir hata oluştu.',
          style: GoogleFonts.outfit(color: AppColors.errorColor),
        ),
      );
    }

    return Stack(
      children: [
        content,
        if (viewModel.isLoading)
          IgnorePointer(
            ignoring: false,
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(32.r),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: LoadingWidget(
                      size: 50.h,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

}
