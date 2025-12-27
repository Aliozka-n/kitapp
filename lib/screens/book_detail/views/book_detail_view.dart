import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/dtos/book_dto.dart';
import '../../../base/constants/app_constants.dart';
import '../../../common_widgets/button_widget.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/book_detail_view_model.dart';

class BookDetailView extends StatelessWidget {
  final BookDetailViewModel viewModel;

  const BookDetailView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = viewModel.book;
    if (book == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, book),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  _buildBookHeader(book),
                  SizedBox(height: 32.h),
                  _buildSectionTitle("ÖZET"),
                  SizedBox(height: 12.h),
                  _buildDescription(book),
                  SizedBox(height: 40.h),
                  _buildMetadata(book),
                  SizedBox(height: 40.h),
                  _buildOwnerCard(context),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomActions(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, BookResponse book) {
    return SliverAppBar(
      expandedHeight: 450.h,
      pinned: true,
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: AppColors.textWhite),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (book.imageUrl != null)
              CachedNetworkImage(
                imageUrl: book.imageUrl!,
                fit: BoxFit.cover,
              )
            else
              Container(
                color: AppColors.secondary,
                child: const Icon(Icons.book, size: 100, color: AppColors.primary),
              ),
            // Gradient Overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.primaryDark],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => viewModel.toggleFavorite(),
          icon: Icon(
            viewModel.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: viewModel.isFavorite ? AppColors.accent : AppColors.textWhite,
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildBookHeader(BookResponse book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.accent,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Text(
            book.type?.toUpperCase() ?? "TÜR BELİRTİLMEMİŞ",
            style: GoogleFonts.syne(
              color: AppColors.textWhite,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          book.name ?? "İsimsiz Kitap",
          style: GoogleFonts.cormorantGaramond(
            fontSize: 40.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.0,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Yazan: ${book.writer ?? 'Bilinmiyor'}",
          style: GoogleFonts.syne(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.syne(
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildDescription(BookResponse book) {
    return Text(
      book.description ?? "Bu kitap için henüz bir açıklama girilmemiş.",
      style: GoogleFonts.instrumentSans(
        fontSize: 16.sp,
        height: 1.7,
        color: AppColors.textPrimary.withOpacity(0.8),
      ),
    );
  }

  Widget _buildMetadata(BookResponse book) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(color: AppColors.primary, width: 1.5),
        boxShadow: AppShadows.sharp,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetaItem("DİL", book.language ?? "TR"),
          _buildVerticalDivider(),
          _buildMetaItem("DURUM", book.status ?? "MÜSAİT"),
          _buildVerticalDivider(),
          _buildMetaItem("TARİH", book.createdAt != null ? "${book.createdAt!.day}.${book.createdAt!.month}.${book.createdAt!.year}" : "-"),
        ],
      ),
    );
  }

  Widget _buildMetaItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.syne(
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textLight,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value.toUpperCase(),
          style: GoogleFonts.syne(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.5,
      height: 30.h,
      color: AppColors.primary.withOpacity(0.2),
    );
  }

  Widget _buildOwnerCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: AppColors.accent,
              border: Border.all(color: AppColors.textWhite, width: 2),
            ),
            child: const Icon(Icons.person, color: AppColors.textWhite),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "KİTAP SAHİBİ",
                  style: GoogleFonts.syne(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  viewModel.ownerName ?? "Kullanıcı",
                  style: GoogleFonts.syne(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
          if (!viewModel.isMyBook)
            IconButton(
              onPressed: () {
                NavigationUtil.navigateToChatDetail(
                  context,
                  viewModel.ownerId ?? "",
                  viewModel.ownerName ?? "Kullanıcı",
                );
              },
              icon: const Icon(Icons.chat_bubble_outline, color: AppColors.textWhite),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    if (viewModel.isMyBook) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: const Border(top: BorderSide(color: AppColors.primary, width: 2)),
        ),
        child: ButtonWidget(
          text: "KİTABI SİL",
          backgroundColor: AppColors.errorColor,
          onPressed: () async {
            final confirmed = await _showDeleteConfirmation(context);
            if (confirmed == true) {
              final success = await viewModel.deleteBook();
              if (success && context.mounted) {
                NavigationUtil.pop(context);
              }
            }
          },
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: const Border(top: BorderSide(color: AppColors.primary, width: 2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ButtonWidget(
              text: "MESAJ GÖNDER",
              onPressed: () => NavigationUtil.navigateToChatDetail(
                context,
                viewModel.ownerId ?? "",
                viewModel.ownerName ?? "Kullanıcı",
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Container(
            width: 56.h,
            height: 56.h,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: IconButton(
              onPressed: () {}, // Share logic
              icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: AppColors.primary, width: 2)),
        title: Text("EMİN MİSİN?", style: GoogleFonts.syne(fontWeight: FontWeight.w800)),
        content: Text("Bu kitabı kütüphanenden kalıcı olarak silmek istediğine emin misin?", style: GoogleFonts.instrumentSans()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("İPTAL", style: GoogleFonts.syne(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("EVET, SİL", style: GoogleFonts.syne(color: AppColors.errorColor, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
