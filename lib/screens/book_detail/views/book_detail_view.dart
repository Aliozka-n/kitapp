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
      backgroundColor: AppColors.backgroundCanvas,
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
          onPressed: () => viewModel.toggleFavoriteWithContext(context),
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
            gradient: AppGradients.cosmic,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: AppShadows.glow,
          ),
          child: Text(
            book.type?.toUpperCase() ?? "TÜR BELİRTİLMEMİŞ",
            style: GoogleFonts.outfit(
              color: AppColors.textWhite,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          book.name ?? "İsimsiz Kitap",
          style: GoogleFonts.outfit(
            fontSize: 36.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          "Yazan: ${book.writer ?? 'Bilinmiyor'}",
          style: GoogleFonts.plusJakartaSans(
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
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
        boxShadow: AppShadows.card,
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
          style: GoogleFonts.outfit(
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.accentCyan,
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
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              gradient: AppGradients.cosmic,
              shape: BoxShape.circle,
              boxShadow: AppShadows.glow,
            ),
            child: const Center(child: Icon(Icons.person_rounded, color: AppColors.textWhite)),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "KİTAP SAHİBİ",
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentCyan,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  viewModel.ownerName ?? "Kullanıcı",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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
              icon: Icon(Icons.chat_bubble_rounded, color: AppColors.accent, size: 24.sp),
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
          color: AppColors.backgroundCanvas,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1.5)),
        ),
        child: ButtonWidget(
          text: "KİTABI SİL",
          backgroundColor: AppColors.errorColor,
          onPressed: () async {
            final confirmed = await _showDeleteConfirmation(context);
            if (confirmed == true && context.mounted) {
              // ViewModel'e context gönder - Başarı/hata dialog'u gösterilecek
              await viewModel.deleteBook(context);
            }
          },
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundCanvas,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1.5)),
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
          GestureDetector(
            onTap: () {}, // Share logic
            child: Container(
              width: 60.h,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
              ),
              child: const Icon(Icons.share_rounded, color: AppColors.accentCyan),
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
        backgroundColor: AppColors.primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: Text("EMİN MİSİN?", style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        content: Text("Bu kitabı kütüphanenden kalıcı olarak silmek istediğine emin misin?", style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("İPTAL", style: GoogleFonts.outfit(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("EVET, SİL", style: GoogleFonts.outfit(color: AppColors.errorColor, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

}
