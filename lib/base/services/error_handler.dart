import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_response.dart';

/// Error Handler - Merkezi hata yönetimi
/// Kullanıcı dostu mesajlar ve loglama için
class ErrorHandler {
  // Private constructor - Singleton pattern
  ErrorHandler._();

  /// Hata mesajını kullanıcı dostu formata çevir
  static String getUserFriendlyMessage(dynamic error) {
    if (error is AuthException) {
      return _handleAuthError(error);
    }

    if (error is PostgrestException) {
      return _handlePostgresError(error);
    }

    if (error is Exception) {
      return _handleGenericError(error);
    }

    return 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
  }

  /// Auth hatalarını işle
  static String _handleAuthError(AuthException error) {
    switch (error.statusCode) {
      case '400':
        return 'Geçersiz istek. Lütfen bilgilerinizi kontrol edin.';
      case '401':
        return 'Giriş yapmanız gerekiyor.';
      case '403':
        return 'Bu işlem için yetkiniz yok.';
      case '404':
        return 'Kullanıcı bulunamadı.';
      case '422':
        return 'Geçersiz e-posta veya şifre.';
      default:
        return error.message.isNotEmpty
            ? error.message
            : 'Giriş yapılırken bir hata oluştu.';
    }
  }

  /// Postgres hatalarını işle
  static String _handlePostgresError(PostgrestException error) {
    switch (error.code) {
      case 'PGRST116':
        return 'Kayıt bulunamadı.';
      case '23505':
        return 'Bu kayıt zaten mevcut.';
      case '23503':
        return 'İlişkili bir kayıt bulunamadı.';
      default:
        return error.message.isNotEmpty
            ? error.message
            : 'Veritabanı hatası oluştu.';
    }
  }

  /// Genel hataları işle
  static String _handleGenericError(Exception error) {
    final message = error.toString().toLowerCase();

    if (message.contains('network') || message.contains('connection')) {
      return 'İnternet bağlantınızı kontrol edin.';
    }

    if (message.contains('timeout')) {
      return 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.';
    }

    if (message.contains('format') || message.contains('parse')) {
      return 'Veri formatı hatası.';
    }

    return 'Bir hata oluştu: ${error.toString()}';
  }

  /// ServiceResponse oluştur (hata için)
  static ServiceResponse<T> createErrorResponse<T>({
    required dynamic error,
    int? statusCode,
  }) {
    return ServiceResponse.error(
      message: getUserFriendlyMessage(error),
      statusCode: statusCode ?? 500,
    );
  }
}

