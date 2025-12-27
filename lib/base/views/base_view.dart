import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../constants/app_size.dart';
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
          gradient: AppGradients.backgroundGradient,
        ),
        child: LoadingWidget(
          size: AppSizes.sizeXXXLarge.h,
          message: 'Yükleniyor...',
        ),
      );
    }

    // UI'ı göster, eğer loading varsa overlay loading ekle
    Widget content;
    try {
      content = widget.builder!(context, viewModel);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('BaseView builder error - ${viewModel.runtimeType}: $e');
        // ignore: avoid_print
        print('Stack trace: $stackTrace');
      }
      content = Center(
        child: Text(
          'Bir hata oluştu.',
          style: const TextStyle(color: Colors.red),
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
              color: AppColors.overlayLight,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(AppSizes.sizeXLarge.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(AppSizes.sizeLarge.w),
                    boxShadow: AppShadows.large,
                  ),
                  child: LoadingWidget(
                    size: AppSizes.sizeXLarge.h,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
