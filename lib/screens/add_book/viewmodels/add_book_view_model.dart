import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../base/services/image_upload_service.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/book_dto.dart';
import '../add_book_service.dart';

/// Add Book ViewModel - Add Book ekranının durum ve iş kuralları
class AddBookViewModel extends BaseViewModel {
  final AddBookService service;

  // PRIVATE FIELDS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController writerController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ImageUploadService _imageUploadService = ImageUploadService();
  String? _errorMessage;
  bool _isSuccess = false;
  String? _selectedGenre;
  String? _selectedLanguage;
  File? _selectedImage;
  String? _imageUrl;

  // PUBLIC GETTERS
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  String? get selectedGenre => _selectedGenre;
  String? get selectedLanguage => _selectedLanguage;
  File? get selectedImage => _selectedImage;
  String? get imageUrl => _imageUrl;
  
  /// Form boş mu kontrol et
  bool get isFormEmpty {
    return nameController.text.trim().isEmpty &&
        writerController.text.trim().isEmpty &&
        descriptionController.text.trim().isEmpty &&
        _selectedGenre == null &&
        _selectedLanguage == null &&
        _selectedImage == null;
  }
  
  void setGenre(String? value) {
    _selectedGenre = value;
    if (value != null) {
      typeController.text = value;
    }
    reloadState();
  }
  
  void setLanguage(String? value) {
    _selectedLanguage = value;
    if (value != null) {
      languageController.text = value;
    }
    reloadState();
  }
  
  /// Görsel seç
  void setSelectedImage(File? image) {
    _selectedImage = image;
    _imageUrl = null; // Yeni görsel seçildiğinde URL'i temizle
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
      // Geçici bir ID oluştur (kitap henüz oluşturulmadığı için)
      final tempBookId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final response = await _imageUploadService.uploadBookImage(
        _selectedImage!,
        tempBookId,
      );
      
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

  // Genre and Language lists
  List<String> get genres => [
        'Fiction',
        'Non-Fiction',
        'Sci-Fi',
        'Mystery',
        'Romance',
        'Thriller',
        'Horror',
        'Fantasy',
        'Biography',
        'History',
        'Classic',
      ];

  List<String> get languages => [
        'English',
        'Turkish',
        'Spanish',
        'French',
        'German',
        'Italian',
        'Other',
      ];


  // Constructor
  AddBookViewModel({required this.service});

  @override
  FutureOr<void> init() async {
    // İlk yükleme işlemleri
  }

  /// Kitap ekle
  Future<bool> addBook(BuildContext context) async {
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

      final request = BookRequest(
        name: nameController.text.trim(),
        writer: writerController.text.trim(),
        type: typeController.text.trim().isNotEmpty ? typeController.text.trim() : _selectedGenre,
        language: languageController.text.trim().isNotEmpty ? languageController.text.trim() : _selectedLanguage,
        description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
        imageUrl: _imageUrl, // Yüklenen görsel URL'i
      );

      final response = await service.addBook(request);

      if (response.isSuccessful && response.data != null) {
        _isSuccess = true;
        _clearForm();
        isLoading = false;
        reloadState();
        return true;
      } else {
        _errorMessage = response.message ?? 'Kitap eklenemedi';
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Kitap eklenirken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }

  /// Form'u temizle
  void _clearForm() {
    nameController.clear();
    writerController.clear();
    typeController.clear();
    languageController.clear();
    descriptionController.clear();
    _selectedGenre = null;
    _selectedLanguage = null;
    _selectedImage = null;
    _imageUrl = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    writerController.dispose();
    typeController.dispose();
    languageController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

