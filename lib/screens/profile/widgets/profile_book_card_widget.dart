import 'package:flutter/material.dart';
import '../../home/widgets/inkwell_book_card_widget.dart';
import '../../../domain/dtos/book_dto.dart';

class ProfileBookCardWidget extends StatelessWidget {
  final BookResponse book;
  final VoidCallback onTap;

  const ProfileBookCardWidget({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkwellBookCardWidget(
      book: book,
      onTap: onTap,
      variant: InkwellBookCardVariant.grid,
    );
  }
}
