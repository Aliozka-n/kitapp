import 'package:flutter/material.dart';
import '../../base/views/base_view.dart';
import '../../common_widgets/alert_dialog_widget.dart';
import 'add_book_service.dart';
import 'viewmodels/add_book_view_model.dart';
import 'views/add_book_view.dart';

/// Add Book Screen - Modern kitap ekleme ekranı
class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  AddBookViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<AddBookViewModel>(
      vmBuilder: (_) {
        _viewModel = AddBookViewModel(service: AddBookService());
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
        child: AddBookView(viewModel: viewModel),
      ),
    );
  }
}
