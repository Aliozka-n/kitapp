import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import 'exchange_service.dart';
import 'viewmodels/exchange_view_model.dart';
import 'views/exchange_view.dart';

/// Exchange Screen - Quantum Book Exchange
/// 
/// Dual Selection: Her iki taraftan da kitap seçilebilir
/// - Sol panel: Kullanıcının kendi müsait kitapları
/// - Sağ panel: Karşı tarafın müsait kitapları
class ExchangeScreen extends StatelessWidget {
  /// Karşı tarafın ID'si
  final String otherUserId;

  /// Karşı tarafın adı
  final String otherUserName;

  const ExchangeScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<ExchangeViewModel>(
      vmBuilder: (context) => ExchangeViewModel(
        service: ExchangeService(),
        otherUserId: otherUserId,
        otherUserName: otherUserName,
      ),
      builder: (context, viewModel) => ExchangeView(
        viewModel: viewModel,
        otherUserName: otherUserName,
      ),
    );
  }
}
