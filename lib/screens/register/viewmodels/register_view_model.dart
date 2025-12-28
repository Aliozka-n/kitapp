import 'dart:async';
import 'package:flutter/material.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/auth_dto.dart';
import '../../../domain/models/turkey_location_model.dart';
import '../../../utils/shared_preferences_util.dart';
import '../register_service.dart';

/// Register ViewModel - Register ekranının durum ve iş kuralları
class RegisterViewModel extends BaseViewModel {
  final RegisterService service;

  // PRIVATE FIELDS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _acceptedTerms = false;
  String? _selectedCity;
  String? _selectedDistrict;

  // PUBLIC GETTERS
  String? get errorMessage => _errorMessage;
  bool get acceptedTerms => _acceptedTerms;
  String? get selectedCity => _selectedCity;
  String? get selectedDistrict => _selectedDistrict;

  /// Tüm illeri getir
  List<String> get allCities => TurkeyLocationModel.allCities;

  /// Seçili ile ait ilçeleri getir
  List<String> get availableDistricts {
    if (_selectedCity == null) return [];
    return TurkeyLocationModel.getDistrictsForCity(_selectedCity!);
  }

  void setAcceptedTerms(bool value) {
    _acceptedTerms = value;
    reloadState();
  }

  /// İl seç
  void setSelectedCity(String? city) {
    _selectedCity = city;
    _selectedDistrict = null; // İl değiştiğinde ilçe sıfırla
    reloadState();
  }

  /// İlçe seç
  void setSelectedDistrict(String? district) {
    _selectedDistrict = district;
    reloadState();
  }
  
  /// Form boş mu kontrol et
  bool get isFormEmpty {
    return nameController.text.trim().isEmpty &&
        emailController.text.trim().isEmpty &&
        passwordController.text.isEmpty &&
        confirmPasswordController.text.isEmpty &&
        _selectedCity == null &&
        _selectedDistrict == null;
  }

  // Constructor
  RegisterViewModel({required this.service});

  @override
  FutureOr<void> init() async {
    // İlk yükleme işlemleri
  }

  /// Register işlemi
  Future<bool> register(BuildContext context) async {
    // Form validation
    if (!formKey.currentState!.validate()) {
      return false;
    }

    formKey.currentState!.save();

    isLoading = true;
    _errorMessage = null;

    try {
      final request = RegisterRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        il: _selectedCity,
        ilce: _selectedDistrict,
      );

      final response = await service.register(request);

      if (response.isSuccessful && response.data != null) {
        // Token'ı kaydet
        if (response.data!.token != null) {
          final prefs = await SharedPreferencesUtil.getInstance();
          await prefs.setToken(response.data!.token!);

          // User ID varsa kaydet
          if (response.data!.user?.id != null) {
            await prefs.setString('userId', response.data!.user!.id!);
          }
        }

        isLoading = false;
        return true;
      } else {
        _errorMessage = response.message ?? 'Kayıt başarısız';
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Kayıt olurken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
