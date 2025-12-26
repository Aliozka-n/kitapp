import 'dart:async';
import 'package:flutter/material.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../forgot_password_service.dart';

/// Forgot Password ViewModel - Şifre sıfırlama ekranının durum ve iş kuralları
class ForgotPasswordViewModel extends BaseViewModel {
  final ForgotPasswordService service;

  // PRIVATE FIELDS
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _isSuccess = false;

  // PUBLIC GETTERS
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  
  /// Form boş mu kontrol et
  bool get isFormEmpty {
    return emailController.text.trim().isEmpty;
  }

  // Constructor
  ForgotPasswordViewModel({required this.service});

  @override
  FutureOr<void> init() async {
    // İlk yükleme işlemleri
  }

  /// Şifre sıfırlama e-postası gönder
  Future<bool> sendResetEmail(BuildContext context) async {
    // Form validation
    if (!formKey.currentState!.validate()) {
      return false;
    }

    formKey.currentState!.save();

    isLoading = true;
    _errorMessage = null;
    _isSuccess = false;

    try {
      final response = await service.resetPassword(
        emailController.text.trim(),
      );

      if (response.isSuccessful) {
        _isSuccess = true;
        _errorMessage = null;
        isLoading = false;
        reloadState();
        return true;
      } else {
        _errorMessage = response.message ?? 'E-posta gönderilemedi';
        _isSuccess = false;
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'E-posta gönderilirken hata oluştu';
      _isSuccess = false;
      isLoading = false;
      reloadState();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}

