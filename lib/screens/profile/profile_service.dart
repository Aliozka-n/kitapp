import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../base/services/error_handler.dart';
import '../../base/services/i_profile_service.dart';
import '../../domain/dtos/user_dto.dart' as dto;

/// Profile Service - Supabase ile profil işlemleri
class ProfileService implements IProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Profil bilgilerini getir
  Future<ServiceResponse<dto.UserResponse>> getProfile() async {
    try {
      // Mevcut kullanıcının ID'sini al
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        return ErrorHandler.createErrorResponse<dto.UserResponse>(
          error: Exception('Kullanıcı giriş yapmamış'),
          statusCode: 401,
        );
      }

      // Supabase'den kullanıcı profilini getir
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      final userResponse = dto.UserResponse.fromJson(
        Map<String, dynamic>.from(response),
      );
      return ServiceResponse.success(
        data: userResponse,
        message: 'Profil yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<dto.UserResponse>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Profil güncelle
  Future<ServiceResponse<dto.UserResponse>> updateProfile(dto.UserRequest request) async {
    try {
      // Mevcut kullanıcının ID'sini al
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        return ErrorHandler.createErrorResponse<dto.UserResponse>(
          error: Exception('Kullanıcı giriş yapmamış'),
          statusCode: 401,
        );
      }

      // Güncellenecek verileri hazırla
      final updateData = <String, dynamic>{};
      if (request.name != null) updateData['name'] = request.name;
      if (request.email != null) updateData['email'] = request.email;
      if (request.il != null) updateData['il'] = request.il;
      if (request.ilce != null) updateData['ilce'] = request.ilce;
      if (request.avatarUrl != null) updateData['avatar_url'] = request.avatarUrl;
      if (request.latitude != null) updateData['latitude'] = request.latitude;
      if (request.longitude != null) updateData['longitude'] = request.longitude;

      // Supabase'de profil güncelle
      final response = await _supabase
          .from('users')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      final userResponse = dto.UserResponse.fromJson(
        Map<String, dynamic>.from(response),
      );
      return ServiceResponse.success(
        data: userResponse,
        message: 'Profil güncellendi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<dto.UserResponse>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Logout işlemi - Supabase session'ı temizle
  Future<ServiceResponse<void>> logout() async {
    try {
      await _supabase.auth.signOut();
      return ServiceResponse.success(
        data: null,
        message: 'Çıkış yapıldı',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<void>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Kullanıcının paylaştığı kitap sayısını getir
  Future<ServiceResponse<int>> getSharedBooksCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ErrorHandler.createErrorResponse<int>(
          error: Exception('Kullanıcı giriş yapmamış'),
          statusCode: 401,
        );
      }

      // Helper function kullan
      final response = await _supabase.rpc(
        'get_user_shared_books_count',
        params: {'user_uuid': userId},
      );

      return ServiceResponse.success(
        data: (response as num).toInt(),
        message: 'Paylaşılan kitap sayısı yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      // Helper function yoksa direkt sorgu yap
      try {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) {
          return ServiceResponse.error(
            message: 'Kullanıcı giriş yapmamış',
            statusCode: 401,
          );
        }

        final response = await _supabase
            .from('books')
            .select('id')
            .eq('user_id', userId)
            .eq('status', 'Müsait');

        return ServiceResponse.success(
          data: (response as List).length,
          message: 'Paylaşılan kitap sayısı yüklendi',
          statusCode: 200,
        );
      } catch (e2) {
        return ErrorHandler.createErrorResponse<int>(
          error: e2,
          statusCode: 500,
        );
      }
    }
  }

  /// Kullanıcının takas ettiği kitap sayısını getir
  Future<ServiceResponse<int>> getSwappedBooksCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ErrorHandler.createErrorResponse<int>(
          error: Exception('Kullanıcı giriş yapmamış'),
          statusCode: 401,
        );
      }

      // Helper function kullan
      final response = await _supabase.rpc(
        'get_user_swapped_books_count',
        params: {'user_uuid': userId},
      );

      return ServiceResponse.success(
        data: (response as num).toInt(),
        message: 'Takas edilen kitap sayısı yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      // Helper function yoksa direkt sorgu yap
      try {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) {
          return ServiceResponse.error(
            message: 'Kullanıcı giriş yapmamış',
            statusCode: 401,
          );
        }

        final response = await _supabase
            .from('book_swaps')
            .select('id')
            .or('requester_id.eq.$userId,owner_id.eq.$userId')
            .eq('status', 'Tamamlandı');

        return ServiceResponse.success(
          data: (response as List).length,
          message: 'Takas edilen kitap sayısı yüklendi',
          statusCode: 200,
        );
      } catch (e2) {
        return ErrorHandler.createErrorResponse<int>(
          error: e2,
          statusCode: 500,
        );
      }
    }
  }

  /// Kullanıcının şu anda paylaştığı kitapları getir
  Future<ServiceResponse<List<Map<String, dynamic>>>> getCurrentlySharedBooks() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ErrorHandler.createErrorResponse<List<Map<String, dynamic>>>(
          error: Exception('Kullanıcı giriş yapmamış'),
          statusCode: 401,
        );
      }

      final response = await _supabase
          .from('books')
          .select()
          .eq('user_id', userId)
          .eq('status', 'Müsait')
          .order('created_at', ascending: false)
          .limit(10);

      final books = (response as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      return ServiceResponse.success(
        data: books,
        message: 'Paylaşılan kitaplar yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<List<Map<String, dynamic>>>(
        error: e,
        statusCode: 500,
      );
    }
  }
}

