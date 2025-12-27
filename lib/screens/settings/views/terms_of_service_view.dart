import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';

/// Terms of Service View - Neo-Ethereal Legal Document
/// 
/// Design Philosophy: Sophisticated Legal meets Modern Editorial
/// - Strong vertical rhythm with numbered sections
/// - Accent color shifts to warm tones for distinction from Privacy
/// - Elegant card-based layout for key terms
/// - Floating index for quick navigation
class TermsOfServiceView extends StatefulWidget {
  const TermsOfServiceView({super.key});

  @override
  State<TermsOfServiceView> createState() => _TermsOfServiceViewState();
}

class _TermsOfServiceViewState extends State<TermsOfServiceView>
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
        // Top Right Glow - Warm accent
        Positioned(
          top: -100.h,
          right: -60.w,
          child: Container(
            width: 280.w,
            height: 280.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom Left Glow
        Positioned(
          bottom: -180.h,
          left: -120.w,
          child: Container(
            width: 400.w,
            height: 400.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentCyan.withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Decorative Line
        Positioned(
          top: 200.h,
          right: 0,
          child: Container(
            width: 100.w,
            height: 2.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.accent.withOpacity(0.2),
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
            AppColors.accent.withOpacity(0.7),
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
              gradient: AppGradients.cosmic,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(
              Icons.gavel_rounded,
              color: Colors.white,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            "ŞARTLAR",
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
          
          SizedBox(height: 32.h),
          
          // Quick Summary Cards
          _buildQuickSummary(),
          
          SizedBox(height: 40.h),
          
          // Last Updated
          _buildLastUpdated(),
          
          SizedBox(height: 32.h),
          
          // Sections
          _buildSection(
            number: "1",
            title: "Kabul ve Onay",
            content: """KitApp'ı kullanarak aşağıdaki şartları kabul etmiş sayılırsınız:

• Bu kullanım şartlarına uymayı kabul edersiniz
• 18 yaşından büyük olduğunuzu veya veli izniniz olduğunu beyan edersiniz
• Hesap bilgilerinizin güvenliğinden siz sorumlusunuz
• Şartlarda yapılacak değişiklikleri takip etmekle yükümlüsünüz""",
          ),
          
          _buildSection(
            number: "2",
            title: "Hesap Oluşturma",
            content: """KitApp'a kayıt olurken:

• Doğru ve güncel bilgiler vermelisiniz
• Her kullanıcı yalnızca bir hesap oluşturabilir
• Hesap bilgilerinizi güncel tutmalısınız
• Şüpheli aktivite tespit edilirse hesabınız askıya alınabilir
• Hesabınızı başkasına devredemezsiniz""",
          ),
          
          _buildSection(
            number: "3",
            title: "Kitap Paylaşım Kuralları",
            content: """Platformda kitap paylaşırken:

• Yalnızca yasal olarak sahip olduğunuz kitapları paylaşabilirsiniz
• Korsan veya telif hakkı ihlali içeren materyaller yasaktır
• Kitap durumunu doğru tanımlamalısınız
• Yanıltıcı fotoğraf veya açıklama kullanmayınız
• Uygunsuz içerikli kitapların paylaşımı yasaktır
• Ticari amaçlı satış yapılamaz""",
          ),
          
          _buildSection(
            number: "4",
            title: "Kullanıcı Davranış Kuralları",
            content: """Topluluk içinde:

• Diğer kullanıcılara saygılı davranın
• Taciz, tehdit veya nefret söylemi yasaktır
• Spam veya istenmeyen mesajlar göndermeyin
• Sahte profil oluşturmayın
• Kişisel bilgileri izinsiz paylaşmayın
• Platform güvenliğini tehlikeye atacak eylemlerden kaçının""",
          ),
          
          _buildSection(
            number: "5",
            title: "Takas ve İletişim",
            content: """Kitap takası sürecinde:

• Takas şartlarını açıkça belirleyin
• Randevulara zamanında katılın
• Güvenli buluşma noktaları tercih edin
• Anlaşmazlıklarda yapıcı olun
• Platform dışı ödeme talepleri risklidir ve sorumluluk kabul edilmez""",
          ),
          
          _buildSection(
            number: "6",
            title: "Fikri Mülkiyet",
            content: """Telif hakları:

• KitApp'ın logosu, tasarımı ve içeriği korunmaktadır
• Kullanıcı içerikleri üzerindeki haklar kullanıcıya aittir
• Platformda paylaşılan içeriklerin kullanım hakkı platformda kalır
• İhlal durumunda yasal işlem başlatılabilir""",
          ),
          
          _buildSection(
            number: "7",
            title: "Sorumluluk Sınırları",
            content: """KitApp:

• Kullanıcılar arası anlaşmazlıklardan sorumlu değildir
• Takas edilen kitapların durumunu garanti etmez
• Hizmet kesintilerinden kaynaklanan zararlardan sorumlu tutulamaz
• Üçüncü taraf bağlantılarının içeriğini kontrol etmez
• Platform "olduğu gibi" sunulmaktadır""",
          ),
          
          _buildSection(
            number: "8",
            title: "Hesap Sonlandırma",
            content: """Hesabınız şu durumlarda kapatılabilir:

• Kendi talebinizle
• Kullanım şartlarının ihlali durumunda
• Uzun süreli hareketsizlik sonrası
• Yasal zorunluluk halinde

Hesap kapatıldığında verileriniz gizlilik politikamıza uygun şekilde işlenir.""",
          ),
          
          _buildSection(
            number: "9",
            title: "Değişiklikler",
            content: """Bu şartlar:

• Önceden bildirimle güncellenebilir
• Değişiklikler yayınlandığı tarihte yürürlüğe girer
• Önemli değişiklikler e-posta ile bildirilir
• Kullanmaya devam etmeniz kabul anlamına gelir""",
          ),
          
          _buildSection(
            number: "10",
            title: "Uygulanacak Hukuk",
            content: """Bu şartlar:

• Türkiye Cumhuriyeti yasalarına tabidir
• Uyuşmazlıklarda öncelikle arabuluculuk tercih edilir""",
            isLast: true,
          ),
          
          SizedBox(height: 60.h),
          
          // Acceptance Footer
          _buildAcceptanceFooter(),
          
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
            color: AppColors.accent.withOpacity(0.1),
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
                  color: AppColors.accent.withOpacity(0.15),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      color: AppColors.accent,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "YASAL BELGE",
                      style: GoogleFonts.outfit(
                        color: AppColors.accent,
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
            "Kullanım\nŞartları",
            style: GoogleFonts.playfairDisplay(
              color: AppColors.textPrimary,
              fontSize: 36.sp,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "KitApp'ı kullanarak bu şartları kabul etmiş olursunuz. Lütfen dikkatlice okuyunuz.",
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

  Widget _buildQuickSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ÖZET",
          style: GoogleFonts.outfit(
            color: AppColors.textMuted,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.check_circle_outline,
                title: "Yasal Kitaplar",
                subtitle: "Sadece size ait",
                color: AppColors.successColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.people_outline,
                title: "Saygılı Ol",
                subtitle: "Topluluk kuralları",
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.security_outlined,
                title: "Güvenlik",
                subtitle: "Bilgilerini koru",
                color: AppColors.accentCyan,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.handshake_outlined,
                title: "Dürüst Ol",
                subtitle: "Doğru bilgi ver",
                color: AppColors.warningColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.primaryLight,
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
            child: Icon(icon, color: color, size: 16.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textMuted,
                    fontSize: 10.sp,
                  ),
                ),
              ],
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
                AppColors.accent,
                AppColors.accent.withOpacity(0.3),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "YÜRÜRLÜK TARİHİ",
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
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppGradients.cosmic,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  number,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14.sp,
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
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Content
        Padding(
          padding: EdgeInsets.only(left: 56.w),
          child: _buildRichText(content),
        ),
        if (!isLast) ...[
          SizedBox(height: 28.h),
          // Decorative Element
          Padding(
            padding: EdgeInsets.only(left: 56.w),
            child: Row(
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withOpacity(0.3),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 28.h),
        ],
      ],
    );
  }

  Widget _buildRichText(String content) {
    return Text(
      content,
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.textSecondary,
        fontSize: 14.sp,
        height: 1.8,
      ),
    );
  }

  Widget _buildAcceptanceFooter() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withOpacity(0.1),
            AppColors.primaryLight.withOpacity(0.5),
          ],
        ),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.handshake_outlined,
            color: AppColors.accent,
            size: 32.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            "Bu şartları kabul ederek\nKitApp ailesine katıldınız",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
