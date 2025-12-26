import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../base/services/error_handler.dart';
import '../../base/services/i_add_book_service.dart';
import '../../domain/dtos/book_dto.dart';

/// Add Book Service - Supabase ile kitap ekleme işlemleri
class AddBookService implements IAddBookService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Yeni kitap ekle
  Future<ServiceResponse<BookResponse>> addBook(BookRequest request) async {
    try {
      // Mevcut kullanıcının ID'sini al
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Kitap verilerini hazırla
      final bookData = <String, dynamic>{
        'name': request.name,
        'writer': request.writer,
        'type': request.type,
        'language': request.language,
        'image_url': request.imageUrl,
        'description': request.description,
        'status': request.status ?? 'Müsait',
        'user_id': userId,
      };

      // Supabase'e kitap ekle
      final response = await _supabase
          .from('books')
          .insert(bookData)
          .select()
          .single();

      final bookResponse = BookResponse.fromJson(
        Map<String, dynamic>.from(response),
      );

      return ServiceResponse.success(
        data: bookResponse,
        message: 'Kitap eklendi',
        statusCode: 201,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<BookResponse>(
        error: e,
        statusCode: 500,
      );
    }
  }
}

