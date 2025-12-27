import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';

/// Privacy Policy View - Neo-Ethereal Legal Document
///
/// Design Philosophy: Editorial Magazine meets Legal Document
/// - Refined typography hierarchy with literary character
/// - Generous whitespace for readability
/// - Subtle accent lines as section dividers
/// - Floating ambient elements for depth
class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ScrollController _scrollController;
  double _scrollProgress = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          if (maxScroll > 0) {
            setState(() {
              _scrollProgress = _scrollController.offset / maxScroll;
            });
          }
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCanvas,
      body: Stack(
        children: [
          // Ambient Background Elements
          _buildAmbientBackground(),

          // Main Content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _animationController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeOutCubic,
                    )),
                    child: _buildContent(),
                  ),
                ),
              ),
            ],
          ),

          // Reading Progress Indicator
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientBackground() {
    return Stack(
      children: [
        // Top Right Glow
        Positioned(
          top: -120.h,
          right: -80.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentCyan.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom Left Glow
        Positioned(
          bottom: -150.h,
          left: -100.w,
          child: Container(
            width: 350.w,
            height: 350.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return SafeArea(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.only(top: 56.h),
        child: LinearProgressIndicator(
          value: _scrollProgress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.accentCyan.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppColors.backgroundCanvas.withOpacity(0.95),
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 16.sp,
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.accentCyan.withOpacity(0.8),
                  AppColors.accentCyan.withOpacity(0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentCyan.withOpacity(0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            "GİZLİLİK",
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          // Hero Section
          _buildHeroSection(),

          SizedBox(height: 40.h),

          // Last Updated
          _buildLastUpdated(),

          SizedBox(height: 32.h),

          // Sections
          _buildSection(
            number: "01",
            title: "Toplanan Veriler",
            content:
                """KitApp olarak, size en iyi deneyimi sunmak için aşağıdaki verileri toplamaktayız:

• **Hesap Bilgileri**: E-posta adresi, kullanıcı adı ve profil fotoğrafı
• **Kitap Verileri**: Eklediğiniz kitapların başlık, yazar, durum ve fotoğraf bilgileri
• **Konum Bilgisi**: Yakınınızdaki kitapları gösterebilmek için yaklaşık konum
• **Mesajlaşma**: Diğer kullanıcılarla yaptığınız görüşmeler
• **Kullanım Verileri**: Uygulama içi etkileşimleriniz ve tercihleriniz""",
          ),

          _buildSection(
            number: "02",
            title: "Veri Kullanımı",
            content:
                """Topladığımız veriler yalnızca aşağıdaki amaçlarla kullanılmaktadır:

• Hesabınızı oluşturmak ve yönetmek
• Kitap takas önerilerini kişiselleştirmek
• Yakınınızdaki kullanıcıları ve kitapları göstermek
• Uygulama performansını iyileştirmek
• Güvenliği sağlamak ve dolandırıcılığı önlemek
• Yasal yükümlülükleri yerine getirmek""",
          ),

          _buildSection(
            number: "03",
            title: "Veri Güvenliği",
            content: """Verilerinizin güvenliği bizim için en önemli önceliktir:

• Tüm veriler SSL/TLS şifreleme ile korunmaktadır
• Şifreleriniz tek yönlü hash algoritmaları ile saklanır
• Düzenli güvenlik denetimleri gerçekleştirilmektedir
• Yetkisiz erişime karşı çok katmanlı koruma uygulanmaktadır
• Veriler Avrupa Birliği standartlarına uygun sunucularda tutulmaktadır""",
          ),

          _buildSection(
            number: "04",
            title: "Veri Paylaşımı",
            content:
                """Kişisel verileriniz üçüncü taraflarla şu durumlarda paylaşılabilir:

• **Diğer Kullanıcılar**: Profil bilgileriniz ve kitaplarınız diğer kullanıcılara görünür
• **Hizmet Sağlayıcılar**: Altyapı ve analiz hizmetleri için güvenilir ortaklarla
• **Yasal Zorunluluk**: Mahkeme kararı veya yasal talep durumunda

Verilerinizi hiçbir koşulda reklam amaçlı satmayız veya paylaşmayız.""",
          ),

          _buildSection(
            number: "05",
            title: "Haklarınız",
            content: """KVKK ve GDPR kapsamında aşağıdaki haklara sahipsiniz:

• Verilerinize erişim talep etme
• Yanlış verilerin düzeltilmesini isteme
• Verilerinizin silinmesini talep etme
• Veri işlemeye itiraz etme
• Verilerinizin taşınabilirliğini talep etme
• Şikayette bulunma hakkı

Bu haklarınızı kullanmak için ayarlar sayfasından hesabınızı yönetebilirsiniz.""",
          ),

          _buildSection(
            number: "06",
            title: "Çerezler ve İzleme",
            content: """Uygulamamız aşağıdaki teknolojileri kullanmaktadır:

• **Oturum Çerezleri**: Giriş durumunuzu korumak için
• **Tercih Çerezleri**: Ayarlarınızı hatırlamak için
• **Analiz Araçları**: Anonim kullanım istatistikleri için

Çerez tercihlerinizi cihaz ayarlarından yönetebilirsiniz.""",
            isLast: true,
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight,
            AppColors.primaryDark.withOpacity(0.8),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.accentCyan.withOpacity(0.15),
                  border: Border.all(
                    color: AppColors.accentCyan.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.accentCyan,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "KVKK & GDPR UYUMLU",
                      style: GoogleFonts.outfit(
                        color: AppColors.accentCyan,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "Gizlilik\nPolitikası",
            style: GoogleFonts.playfairDisplay(
              color: AppColors.textPrimary,
              fontSize: 36.sp,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Verileriniz bizim için değerli. Bu politika, kişisel bilgilerinizi nasıl topladığımızı, kullandığımızı ve koruduğumuzu açıklar.",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accentCyan,
                AppColors.accentCyan.withOpacity(0.3),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SON GÜNCELLEME",
              style: GoogleFonts.outfit(
                color: AppColors.textMuted,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "1 Ocak 2025",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: AppColors.primaryLight,
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Center(
                child: Text(
                  number,
                  style: GoogleFonts.outfit(
                    color: AppColors.accentCyan,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Content
        Padding(
          padding: EdgeInsets.only(left: 64.w),
          child: _buildRichText(content),
        ),
        if (!isLast) ...[
          SizedBox(height: 32.h),
          // Divider
          Container(
            margin: EdgeInsets.only(left: 64.w),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ],
    );
  }

  Widget _buildRichText(String content) {
    // Parse bold text marked with **text**
    final List<InlineSpan> spans = [];
    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    int lastEnd = 0;

    for (final match in boldRegex.allMatches(content)) {
      // Add normal text before the match
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: content.substring(lastEnd, match.start),
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            height: 1.8,
          ),
        ));
      }
      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          height: 1.8,
        ),
      ));
      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < content.length) {
      spans.add(TextSpan(
        text: content.substring(lastEnd),
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary,
          fontSize: 14.sp,
          height: 1.8,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
