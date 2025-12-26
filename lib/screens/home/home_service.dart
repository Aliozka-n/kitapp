import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../base/services/error_handler.dart';
import '../../base/services/i_home_service.dart';
import '../../domain/dtos/book_dto.dart';

/// Home Service - Supabase ile kitap listesi işlemleri
class HomeService implements IHomeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Book listesi getir
  Future<ServiceResponse<List<BookResponse>>> getBooks({
    String? status,
    String? category,
    String? filter,
  }) async {
    try {
      // Query'yi oluştur
      dynamic query = _supabase.from('books').select();

      // Status filtresi (Müsait, Takas Edildi, vb.)
      if (status != null && status != 'Tümü') {
        query = query.eq('status', status);
      } else {
        // Varsayılan olarak sadece müsait kitapları göster
        query = query.eq('status', 'Müsait');
      }

      // Kategori filtresi (type)
      if (category != null && category != 'Tümü') {
        query = query.eq('type', category);
      }

      // Filtreleme (Popüler, Yeni, vb.) - order her zaman en sonda
      query = query.order('created_at', ascending: false);

      final response = await query;

      final books = (response as List)
          .map((item) => BookResponse.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();

      return ServiceResponse.success(
        data: books,
        message: 'Kitaplar yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<List<BookResponse>>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Book ara
  Future<ServiceResponse<List<BookResponse>>> searchBooks(String query) async {
    try {
      // Supabase'de text search için ilike kullan
      final response = await _supabase
          .from('books')
          .select()
          .or('name.ilike.%$query%,writer.ilike.%$query%')
          .order('created_at', ascending: false);

      final books = (response as List)
          .map((item) => BookResponse.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();

      return ServiceResponse.success(
        data: books,
        message: 'Arama tamamlandı',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<List<BookResponse>>(
        error: e,
        statusCode: 500,
      );
    }
  }
}
