import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../base/services/image_upload_service.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/user_dto.dart' as dto;
import '../../../domain/models/turkey_location_model.dart';
import '../edit_profile_service.dart';

/// Edit Profile ViewModel - Profil düzenleme ekranının durum ve iş kuralları
class EditProfileViewModel extends BaseViewModel {
  final EditProfileService service;
  final ImageUploadService _imageUploadService = ImageUploadService();

  // PRIVATE FIELDS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _isSuccess = false;
  dto.UserResponse? _user;
  File? _selectedImage;
  String? _imageUrl;
  String? _selectedCity;
  String? _selectedDistrict;

  // PUBLIC GETTERS
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  dto.UserResponse? get user => _user;
  File? get selectedImage => _selectedImage;
  String? get imageUrl => _imageUrl;
  String? get selectedCity => _selectedCity;
  String? get selectedDistrict => _selectedDistrict;

  /// Tüm illeri getir
  List<String> get allCities => TurkeyLocationModel.allCities;

  /// Seçili ile ait ilçeleri getir
  List<String> get availableDistricts {
    if (_selectedCity == null) return [];
    return TurkeyLocationModel.getDistrictsForCity(_selectedCity!);
  }

  /// Form değişti mi kontrol et
  bool get isFormChanged {
    if (_user == null) return false;

    final nameChanged = nameController.text.trim() != (_user?.name ?? '');
    final emailChanged = emailController.text.trim() != (_user?.email ?? '');
    final ilChanged = _selectedCity != (_user?.il ?? '');
    final ilceChanged = _selectedDistrict != (_user?.ilce ?? '');
    final imageChanged = _selectedImage != null;

    return nameChanged ||
        emailChanged ||
        ilChanged ||
        ilceChanged ||
        imageChanged;
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

  // Constructor
  EditProfileViewModel({required this.service});

  @override
  FutureOr<void> init() async {
    await loadProfile();
  }

  /// Profil bilgilerini yükle
  Future<void> loadProfile() async {
    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.getProfile();

      if (response.isSuccessful && response.data != null) {
        _user = response.data!;

        // Form alanlarını doldur
        nameController.text = _user?.name ?? '';
        emailController.text = _user?.email ?? '';

        // İl/ilçe adlarını normalize et (veritabanından küçük harf gelebilir)
        _selectedCity = TurkeyLocationModel.normalizeCityName(_user?.il);
        _selectedDistrict = _selectedCity != null && _user?.ilce != null
            ? TurkeyLocationModel.normalizeDistrictName(
                _selectedCity, _user?.ilce)
            : null;

        _imageUrl = _user?.avatarUrl;

        _errorMessage = null;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Profil yüklenemedi';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Profil yüklenirken hata oluştu';
      reloadState();
    } finally {
      isLoading = false;
    }
  }

  /// Görsel seç
  void setSelectedImage(File? image) {
    _selectedImage = image;
    reloadState();
  }

  /// Görsel yükle (Supabase Storage'a)
  Future<bool> uploadImage() async {
    if (_selectedImage == null) {
      return true; // Görsel yoksa başarılı say
    }

    isLoading = true;
    _errorMessage = null;

    try {
      final response =
          await _imageUploadService.uploadProfileImage(_selectedImage!);

      if (response.isSuccessful && response.data != null) {
        _imageUrl = response.data!;
        isLoading = false;
        reloadState();
        return true;
      } else {
        _errorMessage = response.message ?? 'Görsel yüklenemedi';
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Görsel yüklenirken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }

  /// Profil güncelle
  Future<bool> updateProfile(BuildContext context) async {
    // Form validation
    if (!formKey.currentState!.validate()) {
      return false;
    }

    formKey.currentState!.save();

    isLoading = true;
    _errorMessage = null;
    _isSuccess = false;

    try {
      // Önce görseli yükle (eğer varsa)
      if (_selectedImage != null) {
        final uploadSuccess = await uploadImage();
        if (!uploadSuccess) {
          isLoading = false;
          reloadState();
          return false;
        }
      }

      final request = dto.UserRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        il: _selectedCity,
        ilce: _selectedDistrict,
        avatarUrl: _imageUrl,
      );

      final response = await service.updateProfile(request);

      if (response.isSuccessful && response.data != null) {
        _user = response.data!;
        _isSuccess = true;
        _errorMessage = null;
        isLoading = false;
        reloadState();
        return true;
      } else {
        _errorMessage = response.message ?? 'Profil güncellenemedi';
        _isSuccess = false;
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Profil güncellenirken hata oluştu';
      _isSuccess = false;
      isLoading = false;
      reloadState();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
