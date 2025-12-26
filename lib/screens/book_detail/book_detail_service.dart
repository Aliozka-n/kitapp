import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../base/services/error_handler.dart';
import '../../base/services/favorites_service.dart';
import '../../base/services/i_book_detail_service.dart';
import '../../domain/dtos/book_dto.dart';

/// Book Detail Service - Supabase ile kitap detay işlemleri
class BookDetailService implements IBookDetailService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FavoritesService _favoritesService = FavoritesService();

  /// Kitap detayı getir
  Future<ServiceResponse<BookResponse>> getBookDetail(String bookId) async {
    try {
      // Supabase'den kitap detayını getir
      final bookResponse = await _supabase
          .from('books')
          .select()
          .eq('id', bookId)
          .single();

      // User bilgisini ayrı olarak çek (rating, avatar_url, location dahil)
      String? userId = bookResponse['user_id']?.toString();
      String? userName;
      double? userRating;
      String? userAvatarUrl;
      double? userLatitude;
      double? userLongitude;
      
      if (userId != null) {
        try {
          final userResponse = await _supabase
              .from('users')
              .select('id, name, email, rating, avatar_url, latitude, longitude')
              .eq('id', userId)
              .maybeSingle();
          
          if (userResponse != null) {
            userName = userResponse['name'] as String?;
            userRating = userResponse['rating'] != null 
                ? (userResponse['rating'] is num 
                    ? userResponse['rating'].toDouble() 
                    : double.tryParse(userResponse['rating'].toString()))
                : null;
            userAvatarUrl = userResponse['avatar_url'] as String?;
            userLatitude = userResponse['latitude'] != null
                ? (userResponse['latitude'] is num
                    ? userResponse['latitude'].toDouble()
                    : double.tryParse(userResponse['latitude'].toString()))
                : null;
            userLongitude = userResponse['longitude'] != null
                ? (userResponse['longitude'] is num
                    ? userResponse['longitude'].toDouble()
                    : double.tryParse(userResponse['longitude'].toString()))
                : null;
          }
        } catch (e) {
          // User bilgisi çekilemezse sessizce geç
        }
      }

      // BookResponse'a user bilgilerini ekle
      final bookData = Map<String, dynamic>.from(bookResponse);
      if (userId != null) {
        bookData['user_id'] = userId;
      }
      if (userName != null) {
        bookData['user_name'] = userName;
      }
      if (userRating != null) {
        bookData['user_rating'] = userRating;
      }
      if (userAvatarUrl != null) {
        bookData['user_avatar_url'] = userAvatarUrl;
      }
      if (userLatitude != null) {
        bookData['user_latitude'] = userLatitude;
      }
      if (userLongitude != null) {
        bookData['user_longitude'] = userLongitude;
      }

      final bookResponseObj = BookResponse.fromJson(bookData);

      return ServiceResponse.success(
        data: bookResponseObj,
        message: 'Kitap detayı yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<BookResponse>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Kitap sil
  Future<ServiceResponse<bool>> deleteBook(String bookId) async {
    try {
      // Mevcut kullanıcının ID'sini al
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Sadece kendi kitabını silebilir (RLS policy ile de korunuyor)
      await _supabase
          .from('books')
          .delete()
          .eq('id', bookId)
          .eq('user_id', userId);

      return ServiceResponse.success(
        data: true,
        message: 'Kitap silindi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<bool>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Kitap güncelle
  Future<ServiceResponse<BookResponse>> updateBook(
    String bookId,
    BookRequest request,
  ) async {
    try {
      // Mevcut kullanıcının ID'sini al
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Güncellenecek verileri hazırla
      final updateData = <String, dynamic>{};
      if (request.name != null) updateData['name'] = request.name;
      if (request.writer != null) updateData['writer'] = request.writer;
      if (request.type != null) updateData['type'] = request.type;
      if (request.language != null) updateData['language'] = request.language;

      // Supabase'de kitap güncelle
      final response = await _supabase
          .from('books')
          .update(updateData)
          .eq('id', bookId)
          .eq('user_id', userId)
          .select()
          .single();

      final bookResponse = BookResponse.fromJson(
        Map<String, dynamic>.from(response),
      );

      return ServiceResponse.success(
        data: bookResponse,
        message: 'Kitap güncellendi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<BookResponse>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Favori ekle
  Future<ServiceResponse<bool>> addFavorite(String bookId) async {
    return await _favoritesService.addFavorite(bookId);
  }

  /// Favori kaldır
  Future<ServiceResponse<bool>> removeFavorite(String bookId) async {
    return await _favoritesService.removeFavorite(bookId);
  }

  /// Favori mi kontrol et
  Future<ServiceResponse<bool>> isFavorite(String bookId) async {
    return await _favoritesService.isFavorite(bookId);
  }
}

