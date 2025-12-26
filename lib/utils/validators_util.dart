import 'extensions/string_extension.dart';

/// Validators Utility - Form validation metodları
class Validators {
  /// Boş alan kontrolü
  static String? emptyFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bu alan boş olamaz';
    }
    return null;
  }

  /// E-posta kontrolü
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return emptyFieldValidator(value);
    }
    if (!value.isValidEmail) {
      return 'Geçersiz e-posta adresi';
    }
    return null;
  }

  /// Minimum karakter kontrolü
  static String? minLengthValidator(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return emptyFieldValidator(value);
    }
    if (value.length < minLength) {
      return 'En az $minLength karakter olmalı';
    }
    return null;
  }

  /// Şifre eşleşme kontrolü
  static String? repeatPasswordValidator(String? repeatPassword, String? password) {
    if (repeatPassword == null || repeatPassword.isEmpty) {
      return emptyFieldValidator(repeatPassword);
    }
    if (repeatPassword != password) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  /// Telefon numarası kontrolü
  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return emptyFieldValidator(value);
    }
    // Basit telefon validasyonu (10-15 karakter arası, sadece rakam)
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Geçersiz telefon numarası';
    }
    return null;
  }
}

