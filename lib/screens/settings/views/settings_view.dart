import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../base/constants/app_constants.dart';
import '../../../utils/navigation_util.dart';
import '../viewmodels/settings_view_model.dart';
import '../widgets/settings_section_widget.dart';
import '../widgets/settings_tile_widget.dart';

/// Settings View - Neo-Ethereal Ayarlar Sayfası
class SettingsView extends StatelessWidget {
  final SettingsViewModel viewModel;

  const SettingsView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCanvas,
      body: Stack(
        children: [
          // Background Ambient Glow - Top Right
          Positioned(
            top: -100.h,
            right: -80.w,
            child: Container(
              width: 280.w,
              height: 280.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.15),
                    AppColors.accent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          // Background Ambient Glow - Bottom Left
          Positioned(
            bottom: -120.h,
            left: -100.w,
            child: Container(
              width: 320.w,
              height: 320.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentCyan.withOpacity(0.08),
                    AppColors.accentCyan.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),

                      // Account Section
                      _buildAccountSection(context),

                      SizedBox(height: 28.h),

                      // About Section
                      _buildAboutSection(context),

                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// App Bar
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppColors.backgroundCanvas.withOpacity(0.9),
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
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
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            "AYARLAR",
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  /// Hesap Bölümü
  Widget _buildAccountSection(BuildContext context) {
    return SettingsSectionWidget(
      title: "HESAP",
      icon: Icons.person_outline_rounded,
      iconColor: AppColors.accent,
      children: [
        SettingsTileWidget(
          title: "Profili Düzenle",
          subtitle: "İsim, fotoğraf ve konum",
          icon: Icons.edit_outlined,
          onTap: () => NavigationUtil.navigateToEditProfile(context),
        ),
        SettingsTileWidget(
          title: "Şifre Değiştir",
          subtitle: "Hesap güvenliğini güncelle",
          icon: Icons.lock_outline_rounded,
          onTap: () => _showChangePasswordSheet(context),
        ),
        _buildDeleteAccountTile(context),
      ],
    );
  }

  /// Hesap Silme Tile - Danger Zone Styling
  Widget _buildDeleteAccountTile(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          _showDeleteAccountSheet(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.errorColor.withOpacity(0.08),
                Colors.transparent,
              ],
            ),
          ),
          child: Row(
            children: [
              // Icon Container with danger glow
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  color: AppColors.errorColor.withOpacity(0.15),
                  border: Border.all(
                    color: AppColors.errorColor.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.errorColor.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_off_outlined,
                  color: AppColors.errorColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hesabı Sil",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.errorColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Kalıcı olarak tüm verileri sil",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.errorColor.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.errorColor.withOpacity(0.5),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hesap Silme Bottom Sheet - Dramatic Confirmation Flow
  void _showDeleteAccountSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (sheetContext) => _DeleteAccountSheet(viewModel: viewModel),
    );
  }

  /// Hakkında Bölümü
  Widget _buildAboutSection(BuildContext context) {
    return SettingsSectionWidget(
      title: "HAKKINDA",
      icon: Icons.info_outline_rounded,
      iconColor: AppColors.infoColor,
      children: [
        SettingsTileWidget(
          title: "Gizlilik Politikası",
          subtitle: "Veri kullanımı hakkında",
          icon: Icons.policy_outlined,
          onTap: () => NavigationUtil.navigateToPrivacyPolicy(context),
          showChevron: true,
        ),
        SettingsTileWidget(
          title: "Kullanım Şartları",
          subtitle: "Hizmet koşulları",
          icon: Icons.description_outlined,
          onTap: () => NavigationUtil.navigateToTermsOfService(context),
          showChevron: true,
        ),
        SettingsTileWidget(
          title: "Uygulama Sürümü",
          subtitle: "v${viewModel.appVersion}",
          icon: Icons.verified_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
          },
        ),
      ],
    );
  }

  /// Şifre değiştirme bottom sheet
  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                // Title
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppGradients.cosmic,
                      ),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      "ŞİFRE DEĞİŞTİR",
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                // Current Password
                _buildPasswordField(
                  controller: viewModel.currentPasswordController,
                  label: "Mevcut Şifre",
                  hint: "Mevcut şifrenizi girin",
                ),
                SizedBox(height: 20.h),
                // New Password
                _buildPasswordField(
                  controller: viewModel.newPasswordController,
                  label: "Yeni Şifre",
                  hint: "Yeni şifrenizi girin",
                ),
                SizedBox(height: 20.h),
                // Confirm Password
                _buildPasswordField(
                  controller: viewModel.confirmPasswordController,
                  label: "Şifre Tekrar",
                  hint: "Yeni şifrenizi tekrar girin",
                ),
                SizedBox(height: 32.h),
                // Save Button
                GestureDetector(
                  onTap: () async {
                    final success = await viewModel.changePassword(context);
                    if (success && context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Şifre başarıyla değiştirildi'),
                          backgroundColor: AppColors.successColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          margin: EdgeInsets.all(16.w),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    decoration: BoxDecoration(
                      gradient: AppGradients.cosmic,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: AppShadows.glow,
                    ),
                    child: Center(
                      child: Text(
                        "ŞİFREYİ GÜNCELLE",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Password field builder
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: true,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 15.sp,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: AppColors.textMuted,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: AppColors.primaryLight,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bu alan boş bırakılamaz';
            }
            if (value.length < 6) {
              return 'Şifre en az 6 karakter olmalı';
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Delete Account Sheet - Dramatic Confirmation with Double Password
class _DeleteAccountSheet extends StatefulWidget {
  final SettingsViewModel viewModel;

  const _DeleteAccountSheet({required this.viewModel});

  @override
  State<_DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<_DeleteAccountSheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();
  bool _isLoading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
  String? _errorMessage;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    if (!_formKey.currentState!.validate()) return;

    if (_password1Controller.text != _password2Controller.text) {
      setState(() => _errorMessage = 'Şifreler eşleşmiyor');
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await widget.viewModel.deleteAccountWithPassword(
      context,
      _password1Controller.text,
    );

    if (!success && mounted) {
      setState(() {
        _isLoading = false;
        _errorMessage = widget.viewModel.errorMessage ?? 'Şifre yanlış';
      });
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        border: Border.all(color: AppColors.errorColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.errorColor.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.errorColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 32.h),

              // Animated Warning Icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.errorColor.withOpacity(0.2),
                          AppColors.errorColor.withOpacity(0.05),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.errorColor.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.errorColor,
                      size: 40.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                "HESABI SİL",
                style: GoogleFonts.outfit(
                  color: AppColors.errorColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              SizedBox(height: 12.h),

              // Warning Message
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: AppColors.errorColor.withOpacity(0.08),
                  border: Border.all(
                    color: AppColors.errorColor.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.errorColor.withOpacity(0.8),
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        "Bu işlem geri alınamaz. Tüm kitapların, favorilerin ve mesajların silinecek.",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),

              // Password Fields Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Onaylamak için şifreni iki kez gir",
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textMuted,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Password Field 1
              _buildDangerPasswordField(
                controller: _password1Controller,
                hint: "Şifreni gir",
                obscure: _obscure1,
                onToggle: () => setState(() => _obscure1 = !_obscure1),
              ),
              SizedBox(height: 16.h),

              // Password Field 2
              _buildDangerPasswordField(
                controller: _password2Controller,
                hint: "Şifreni tekrar gir",
                obscure: _obscure2,
                onToggle: () => setState(() => _obscure2 = !_obscure2),
              ),

              // Error Message
              if (_errorMessage != null) ...[
                SizedBox(height: 16.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.errorColor.withOpacity(0.15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.errorColor,
                        size: 18.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.errorColor,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 32.h),

              // Action Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "İPTAL",
                            style: GoogleFonts.outfit(
                              color: AppColors.textSecondary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Delete Button
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _isLoading ? null : _handleDelete,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.errorColor,
                              AppColors.errorColor.withOpacity(0.8),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.errorColor.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "HESABI SİL",
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.textPrimary,
        fontSize: 15.sp,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted,
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: AppColors.primaryLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 16.h,
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: AppColors.errorColor.withOpacity(0.6),
          size: 20.sp,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textMuted,
            size: 20.sp,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.errorColor.withOpacity(0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.errorColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.errorColor,
            width: 1.5,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Şifre gerekli';
        }
        if (value.length < 6) {
          return 'Şifre en az 6 karakter olmalı';
        }
        return null;
      },
    );
  }
}
