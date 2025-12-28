import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/dtos/book_dto.dart';
import '../constants/exchange_style.dart';
import '../viewmodels/exchange_view_model.dart';
import '../widgets/swap_book_card_widget.dart';
import '../widgets/swap_arrow_widget.dart';
import '../widgets/swap_success_dialog_widget.dart';
import '../widgets/book_mini_card_widget.dart';

/// Exchange View - Quantum Book Exchange UI
/// 
/// Dual Selection Interface:
/// - Sol panel: Benim kitaplarım (Cyan/Quantum)
/// - Sağ panel: Karşı tarafın kitapları (Amber)
class ExchangeView extends StatelessWidget {
  final ExchangeViewModel viewModel;
  final String otherUserName;

  const ExchangeView({
    super.key,
    required this.viewModel,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ExchangeStyle.void_,
      body: ExchangeBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(context),

              // İçerik
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.h),

                      // Swap visualizer - Seçili iki kitap ve ok
                      _buildSwapVisualizer(context),

                      SizedBox(height: 24.h),

                      // Benim kitaplarım bölümü
                      _buildMyBooksSection(context),

                      SizedBox(height: 20.h),

                      // Karşı tarafın kitapları bölümü
                      _buildOtherUserBooksSection(context),

                      SizedBox(height: 24.h),

                      // Mesaj alanı
                      _buildMessageSection(context),

                      SizedBox(height: 24.h),

                      // Gönder butonu
                      _buildSendButton(context),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ExchangeStyle.void_,
            ExchangeStyle.void_.withValues(alpha: 0),
          ],
        ),
      ),
      child: Row(
        children: [
          // Geri butonu
          _buildIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            color: ExchangeStyle.quantum,
            onTap: () => Navigator.pop(context),
          ),

          SizedBox(width: 16.w),

          // Başlık
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.swap_horiz_rounded,
                      size: 20.sp,
                      color: ExchangeStyle.quantum,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'QUANTUM TAKAS',
                      style: ExchangeStyle.headline(fontSize: 16.sp),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  '$otherUserName ile takas',
                  style: ExchangeStyle.label(
                    color: ExchangeStyle.amber,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),

          // Bilgi butonu
          _buildIconButton(
            icon: Icons.info_outline_rounded,
            color: ExchangeStyle.amber,
            onTap: () => _showHelpDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 42.h,
        decoration: BoxDecoration(
          color: ExchangeStyle.nebula,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildSwapVisualizer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sol taraf - Benim seçtiğim kitap
          Expanded(
            child: viewModel.selectedMyBook != null
                ? SwapBookCardWidget(
                    book: viewModel.selectedMyBook!,
                    isOffered: true,
                    isSelected: true,
                    onTap: () => viewModel.clearMySelection(),
                  )
                : _buildEmptyBookSlot(
                    label: 'KİTABINIZI\nSEÇİN',
                    sublabel: 'Aşağıdan seçin',
                    color: ExchangeStyle.quantum,
                    icon: Icons.arrow_downward_rounded,
                  ),
          ),

          // Orta - Swap ok animasyonu
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 60.h),
            child: SwapArrowWidget(
              isActive: viewModel.canSendProposal,
            ),
          ),

          // Sağ taraf - Karşı tarafın seçtiğim kitabı
          Expanded(
            child: viewModel.selectedOtherBook != null
                ? SwapBookCardWidget(
                    book: viewModel.selectedOtherBook!,
                    isOffered: false,
                    isSelected: true,
                    onTap: () => viewModel.clearOtherSelection(),
                  )
                : _buildEmptyBookSlot(
                    label: 'KARŞI TARAFIN\nKİTABI',
                    sublabel: 'Aşağıdan seçin',
                    color: ExchangeStyle.amber,
                    icon: Icons.arrow_downward_rounded,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBookSlot({
    required String label,
    required String sublabel,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: ExchangeStyle.cardRadius,
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.05),
            color.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: AspectRatio(
        aspectRatio: 0.55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated pulse icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 32.sp,
                      color: color.withValues(alpha: 0.7),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
            Text(
              label,
              style: ExchangeStyle.label(
                color: color,
                fontSize: 11.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              sublabel,
              style: ExchangeStyle.body(
                fontSize: 10.sp,
                color: ExchangeStyle.dim,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyBooksSection(BuildContext context) {
    return _buildBookSelectionSection(
      title: 'BENİM KİTAPLARIM',
      subtitle: 'Takas için bir kitabınızı seçin',
      color: ExchangeStyle.quantum,
      icon: Icons.person_outline_rounded,
      books: viewModel.myBooks,
      selectedBook: viewModel.selectedMyBook,
      onBookSelected: viewModel.selectMyBook,
      emptyMessage: 'Müsait kitabınız yok',
    );
  }

  Widget _buildOtherUserBooksSection(BuildContext context) {
    return _buildBookSelectionSection(
      title: '$otherUserName KİTAPLARI'.toUpperCase(),
      subtitle: 'İstediğiniz kitabı seçin',
      color: ExchangeStyle.amber,
      icon: Icons.people_outline_rounded,
      books: viewModel.otherUserBooks,
      selectedBook: viewModel.selectedOtherBook,
      onBookSelected: viewModel.selectOtherBook,
      emptyMessage: 'Müsait kitap bulunamadı',
    );
  }

  Widget _buildBookSelectionSection({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required List<BookResponse> books,
    required BookResponse? selectedBook,
    required void Function(BookResponse) onBookSelected,
    required String emptyMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 18.sp,
                  color: color,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: ExchangeStyle.title(
                        fontSize: 13.sp,
                        color: color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: ExchangeStyle.body(
                        fontSize: 10.sp,
                        color: ExchangeStyle.dim,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: ExchangeStyle.nebula,
                  borderRadius: ExchangeStyle.chipRadius,
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${books.length} kitap',
                  style: ExchangeStyle.label(
                    fontSize: 10.sp,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Kitap listesi
        if (books.isEmpty)
          _buildEmptyState(emptyMessage, color)
        else
          SizedBox(
            height: 160.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final isSelected = selectedBook?.id == book.id;
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: BookMiniCardWidget(
                    book: book,
                    isSelected: isSelected,
                    accentColor: color,
                    onTap: () => onBookSelected(book),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(String message, Color color) {
    return Container(
      height: 120.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: ExchangeStyle.cardRadius,
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        color: ExchangeStyle.nebula.withValues(alpha: 0.5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 32.sp,
              color: color.withValues(alpha: 0.4),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: ExchangeStyle.body(color: ExchangeStyle.dim),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ExchangeGlassPanel(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.message_outlined,
                  size: 16.sp,
                  color: ExchangeStyle.quantum,
                ),
                SizedBox(width: 8.w),
                Text(
                  'TAKAS MESAJI',
                  style: ExchangeStyle.label(
                    fontSize: 11.sp,
                    color: ExchangeStyle.quantum,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: ExchangeStyle.dim.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'İsteğe bağlı',
                    style: ExchangeStyle.label(
                      fontSize: 9.sp,
                      color: ExchangeStyle.dim,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: viewModel.messageController,
              style: ExchangeStyle.body(fontSize: 13.sp),
              maxLines: 2,
              maxLength: 150,
              decoration: InputDecoration(
                hintText: 'Takas teklifinize bir mesaj ekleyin...',
                hintStyle: ExchangeStyle.body(
                  fontSize: 13.sp,
                  color: ExchangeStyle.dim,
                ),
                filled: true,
                fillColor: ExchangeStyle.void_.withValues(alpha: 0.5),
                contentPadding: EdgeInsets.all(12.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: ExchangeStyle.quantum.withValues(alpha: 0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: ExchangeStyle.quantum.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: ExchangeStyle.quantum,
                  ),
                ),
                counterStyle: ExchangeStyle.label(
                  fontSize: 9.sp,
                  color: ExchangeStyle.dim,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    final isEnabled = viewModel.canSendProposal && !viewModel.isLoading;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: isEnabled ? () => _handleSendProposal(context) : null,
        child: AnimatedContainer(
          duration: ExchangeStyle.normal,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            gradient: isEnabled
                ? LinearGradient(
                    colors: [
                      ExchangeStyle.quantum,
                      ExchangeStyle.quantum.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            color: isEnabled ? null : ExchangeStyle.nebula,
            borderRadius: ExchangeStyle.buttonRadius,
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: ExchangeStyle.quantum.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
            border: Border.all(
              color: isEnabled
                  ? ExchangeStyle.quantum
                  : ExchangeStyle.stardust,
            ),
          ),
          child: viewModel.isLoading
              ? Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ExchangeStyle.void_,
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send_rounded,
                      size: 20.sp,
                      color: isEnabled
                          ? ExchangeStyle.void_
                          : ExchangeStyle.dim,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'TAKAS TEKLİFİ GÖNDER',
                      style: ExchangeStyle.label(
                        fontSize: 13.sp,
                        color: isEnabled
                            ? ExchangeStyle.void_
                            : ExchangeStyle.dim,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ExchangeStyle.nebula,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: ExchangeStyle.quantum.withValues(alpha: 0.3),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.help_outline_rounded,
              color: ExchangeStyle.quantum,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Nasıl Çalışır?',
              style: ExchangeStyle.title(color: ExchangeStyle.bright),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem('1', 'Kendi kitaplarınızdan birini seçin', ExchangeStyle.quantum),
            SizedBox(height: 12.h),
            _buildHelpItem('2', 'Karşı tarafın kitaplarından birini seçin', ExchangeStyle.amber),
            SizedBox(height: 12.h),
            _buildHelpItem('3', 'İsterseniz bir mesaj ekleyin', ExchangeStyle.dim),
            SizedBox(height: 12.h),
            _buildHelpItem('4', 'Takas teklifini gönderin!', ExchangeStyle.success),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ANLADIM',
              style: ExchangeStyle.label(color: ExchangeStyle.quantum),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String number, String text, Color color) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.2),
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(
              number,
              style: ExchangeStyle.label(
                fontSize: 11.sp,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: ExchangeStyle.body(
              fontSize: 12.sp,
              color: ExchangeStyle.text,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSendProposal(BuildContext context) async {
    final success = await viewModel.sendSwapProposal();

    if (success && context.mounted) {
      await SwapSuccessDialogWidget.show(
        context,
        bookName: viewModel.selectedOtherBook?.name ?? 'Kitap',
        onDismiss: () {
          Navigator.pop(context); // Dialog'u kapat
          Navigator.pop(context); // Exchange ekranından çık
        },
      );
    } else if (viewModel.errorMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage!),
          backgroundColor: ExchangeStyle.error,
        ),
      );
    }
  }
}
