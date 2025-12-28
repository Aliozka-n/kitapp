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
    String? city,
    String? district,
  }) async {
    try {
      // Önce il/ilçe filtresi varsa user ID'lerini bul
      Set<String>? filteredUserIds;
      if (city != null && city.isNotEmpty ||
          district != null && district.isNotEmpty) {
        dynamic userQuery = _supabase.from('users').select('id');

        if (city != null && city.isNotEmpty) {
          userQuery = userQuery.eq('il', city);
        }
        if (district != null && district.isNotEmpty) {
          userQuery = userQuery.eq('ilce', district);
        }

        final userResponse = await userQuery;
        filteredUserIds = (userResponse as List)
            .map((user) => user['id']?.toString())
            .whereType<String>()
            .toSet();

        // Eğer filtre ile eşleşen kullanıcı yoksa boş liste döndür
        if (filteredUserIds.isEmpty) {
          return ServiceResponse.success(
            data: <BookResponse>[],
            message: 'Kitaplar yüklendi',
            statusCode: 200,
          );
        }
      }

      // Query'yi oluştur
      // Not: Join kullanmak yerine, user ID'leri ile filtreleme yapıyoruz
      // çünkü RLS politikaları join'i engelleyebilir
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

      // İl/ilçe filtresi - user ID'lerine göre filtrele
      if (filteredUserIds != null && filteredUserIds.isNotEmpty) {
        // Supabase'de birden fazla değer ile filtreleme
        // Her bir user_id için OR koşulu oluştur
        final userIdsList = filteredUserIds.toList();
        if (userIdsList.length == 1) {
          query = query.eq('user_id', userIdsList[0]);
        } else {
          // Birden fazla ID için OR kullan
          final orConditions =
              userIdsList.map((id) => 'user_id.eq.$id').join(',');
          query = query.or(orConditions);
        }
      }

      // Filtreleme (Popüler, Yeni, vb.) - order her zaman en sonda
      query = query.order('created_at', ascending: false);

      final response = await query;

      // User bilgilerini toplu olarak çek (performans için)
      final userIds = (response as List)
          .map((item) => item['user_id']?.toString())
          .whereType<String>()
          .toSet();

      Map<String, Map<String, dynamic>> userDataMap = {};
      if (userIds.isNotEmpty) {
        try {
          final userIdsList = userIds.toList();
          dynamic usersQuery = _supabase.from('users').select('id, il, ilce');

          // Birden fazla ID için OR koşulu
          if (userIdsList.length == 1) {
            usersQuery = usersQuery.eq('id', userIdsList[0]);
          } else {
            final orConditions = userIdsList.map((id) => 'id.eq.$id').join(',');
            usersQuery = usersQuery.or(orConditions);
          }

          final usersResponse = await usersQuery;

          for (var user in (usersResponse as List)) {
            final userId = user['id']?.toString();
            if (userId != null) {
              userDataMap[userId] = Map<String, dynamic>.from(user);
            }
          }
        } catch (e) {
          // User bilgileri çekilemezse sessizce devam et
        }
      }

      final books = (response as List<dynamic>).map((item) {
        final itemMap = Map<String, dynamic>.from(item);
        final userId = itemMap['user_id']?.toString();

        // User bilgilerini ekle
        if (userId != null && userDataMap.containsKey(userId)) {
          final userData = userDataMap[userId]!;
          itemMap['user_il'] = userData['il'];
          itemMap['user_ilce'] = userData['ilce'];
        }

        return BookResponse.fromJson(itemMap);
      }).toList();

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
