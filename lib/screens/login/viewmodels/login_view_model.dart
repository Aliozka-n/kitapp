import 'dart:async';
import 'package:flutter/material.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/auth_dto.dart';
import '../../../utils/shared_preferences_util.dart';
import '../login_service.dart';

/// Login ViewModel - Login ekranının durum ve iş kuralları
class LoginViewModel extends BaseViewModel {
  final LoginService service;

  // PRIVATE FIELDS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  String? _errorMessage;

  // PUBLIC GETTERS
  bool get rememberMe => _rememberMe;
  String? get errorMessage => _errorMessage;

  // Constructor
  LoginViewModel({required this.service});

  @override
  FutureOr<void> init() async {
    // Önceki oturumdan veri yükleme (eğer remember me seçiliyse)
    await loadRememberedCredentials();
  }

  /// Remember me checkbox'ı değiştir
  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    reloadState();
    
    // Remember me seçiliyse durumu kaydet, değilse temizle
    final prefs = await SharedPreferencesUtil.getInstance();
    if (value) {
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.setBool('rememberMe', false);
      final rememberedEmail = prefs.getString('rememberedEmail');
      await prefs.remove('rememberedEmail');
      // Eğer checkbox kaldırıldıysa ve email kaydedilen email ise temizle
      if (rememberedEmail != null && emailController.text.trim() == rememberedEmail) {
        emailController.clear();
        reloadState();
      }
    }
  }

  /// Login işlemi
  Future<bool> login(BuildContext context) async {
    // Form validation
    if (!formKey.currentState!.validate()) {
      return false;
    }

    formKey.currentState!.save();

    isLoading = true;
    _errorMessage = null;

    try {
      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
        rememberMe: _rememberMe,
      );

      final response = await service.login(request);

      if (response.isSuccessful && response.data != null) {
        // Token'ı kaydet
        if (response.data!.token != null) {
          final prefs = await SharedPreferencesUtil.getInstance();
          await prefs.setToken(response.data!.token!);

          // User ID varsa kaydet (UUID string olarak)
          if (response.data!.user?.id != null) {
            await prefs.setString('userId', response.data!.user!.id!);
          }
        }

        // Remember me seçiliyse email'i kaydet
        final prefs = await SharedPreferencesUtil.getInstance();
        if (_rememberMe) {
          await prefs.setString('rememberedEmail', emailController.text.trim());
          await prefs.setBool('rememberMe', true);
        } else {
          await prefs.remove('rememberedEmail');
          await prefs.setBool('rememberMe', false);
        }

        isLoading = false;
        return true;
      } else {
        _errorMessage = response.message ?? 'Giriş başarısız';
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Giriş yapılırken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }

  /// Önceki oturumdan email'i yükle
  Future<void> loadRememberedCredentials() async {
    try {
      final prefs = await SharedPreferencesUtil.getInstance();
      final rememberMeValue = prefs.getBool('rememberMe') ?? false;
      
      if (rememberMeValue) {
        final rememberedEmail = prefs.getString('rememberedEmail');
        if (rememberedEmail != null && rememberedEmail.isNotEmpty) {
          emailController.text = rememberedEmail;
          _rememberMe = true;
          reloadState();
        }
      }
    } catch (e) {
      // Hata durumunda sessizce devam et
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
