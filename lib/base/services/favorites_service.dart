import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_response.dart';
import '../../domain/dtos/book_dto.dart';

/// Favorites Service - Supabase ile favori kitaplar işlemleri
class FavoritesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Favori kitap ekle
  Future<ServiceResponse<bool>> addFavorite(String bookId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Favori ekle
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'book_id': bookId,
      });

      return ServiceResponse.success(
        data: true,
        message: 'Favorilere eklendi',
        statusCode: 200,
      );
    } catch (e) {
      // Zaten favorilerde ise hata verme
      if (e.toString().contains('duplicate') || e.toString().contains('unique')) {
        return ServiceResponse.success(
          data: true,
          message: 'Zaten favorilerde',
          statusCode: 200,
        );
      }
      return ServiceResponse.error(
        message: 'Favori eklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Favori kitap kaldır
  Future<ServiceResponse<bool>> removeFavorite(String bookId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Favoriyi kaldır
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('book_id', bookId);

      return ServiceResponse.success(
        data: true,
        message: 'Favorilerden kaldırıldı',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Favori kaldırılırken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Favori kitapları getir
  Future<ServiceResponse<List<BookResponse>>> getFavorites() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Favori kitapları getir (join ile)
      final response = await _supabase
          .from('favorites')
          .select('books(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final books = (response as List)
          .map((item) {
            final bookData = item['books'] as Map<String, dynamic>?;
            if (bookData != null) {
              return BookResponse.fromJson(bookData);
            }
            return null;
          })
          .whereType<BookResponse>()
          .toList();

      return ServiceResponse.success(
        data: books,
        message: 'Favori kitaplar yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Favori kitaplar yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Kitap favori mi kontrol et
  Future<ServiceResponse<bool>> isFavorite(String bookId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.success(
          data: false,
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 200,
        );
      }

      // Favori kontrolü
      final response = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('book_id', bookId)
          .maybeSingle();

      return ServiceResponse.success(
        data: response != null,
        message: 'Favori kontrolü yapıldı',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Favori kontrolü yapılırken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}

