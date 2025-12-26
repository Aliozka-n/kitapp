import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_response.dart';

/// Image Upload Service - Supabase Storage ile görsel yükleme işlemleri
class ImageUploadService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _bucketName = 'book-images';

  /// Kitap görseli yükle
  Future<ServiceResponse<String>> uploadBookImage(File imageFile, String bookId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Dosya adını oluştur: userId/bookId-timestamp.jpg
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/$bookId-$timestamp.jpg';

      // Görseli yükle
      await _supabase.storage.from(_bucketName).upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      // Public URL'i al
      final imageUrl = _supabase.storage.from(_bucketName).getPublicUrl(fileName);

      return ServiceResponse.success(
        data: imageUrl,
        message: 'Görsel yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Görsel yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Profil fotoğrafı yükle
  Future<ServiceResponse<String>> uploadProfileImage(File imageFile) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Dosya adını oluştur: userId/profile-timestamp.jpg
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/profile-$timestamp.jpg';

      // Görseli yükle
      await _supabase.storage.from(_bucketName).upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      // Public URL'i al
      final imageUrl = _supabase.storage.from(_bucketName).getPublicUrl(fileName);

      return ServiceResponse.success(
        data: imageUrl,
        message: 'Profil fotoğrafı yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Profil fotoğrafı yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Görsel sil
  Future<ServiceResponse<bool>> deleteImage(String imageUrl) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // URL'den dosya adını çıkar
      final fileName = imageUrl.split('/').last;
      final fullPath = '$userId/$fileName';

      // Görseli sil
      await _supabase.storage.from(_bucketName).remove([fullPath]);

      return ServiceResponse.success(
        data: true,
        message: 'Görsel silindi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Görsel silinirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}

