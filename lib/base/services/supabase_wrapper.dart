import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_response.dart';
import 'error_handler.dart';

/// Supabase Wrapper - Supabase işlemlerini merkezi olarak yönetir
/// Bu wrapper, Supabase client'ını doğrudan kullanmak yerine
/// merkezi bir katman sağlar ve hata yönetimini standartlaştırır
class SupabaseWrapper {
  // Singleton pattern
  static final SupabaseWrapper _instance = SupabaseWrapper._internal();
  factory SupabaseWrapper() => _instance;
  SupabaseWrapper._internal();

  /// Supabase client'ına erişim
  SupabaseClient get client => Supabase.instance.client;

  /// Mevcut kullanıcı ID'sini getir
  String? get currentUserId => client.auth.currentUser?.id;

  /// Kullanıcı giriş yapmış mı?
  bool get isAuthenticated => currentUserId != null;

  /// Tablodan veri çek (SELECT)
  Future<ServiceResponse<List<Map<String, dynamic>>>> select({
    required String table,
    String? select,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    try {
      dynamic query = client.from(table).select(select ?? '*');

      // Filtreler uygula
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      // Sıralama
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      // Limit
      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return ServiceResponse.success(
        data: (response as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<List<Map<String, dynamic>>>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Tek kayıt getir (SELECT single)
  Future<ServiceResponse<Map<String, dynamic>>> selectSingle({
    required String table,
    String? select,
    Map<String, dynamic>? filters,
  }) async {
    try {
      var query = client.from(table).select(select ?? '*');

      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      final response = await query.single();
      return ServiceResponse.success(
        data: Map<String, dynamic>.from(response),
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<Map<String, dynamic>>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Yeni kayıt ekle (INSERT)
  Future<ServiceResponse<Map<String, dynamic>>> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await client
          .from(table)
          .insert(data)
          .select()
          .single();

      return ServiceResponse.success(
        data: Map<String, dynamic>.from(response),
        statusCode: 201,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<Map<String, dynamic>>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Kayıt güncelle (UPDATE)
  Future<ServiceResponse<Map<String, dynamic>>> update({
    required String table,
    required Map<String, dynamic> data,
    required Map<String, dynamic> filters,
  }) async {
    try {
      var query = client.from(table).update(data);

      filters.forEach((key, value) {
        query = query.eq(key, value);
      });

      final response = await query.select().single();
      return ServiceResponse.success(
        data: Map<String, dynamic>.from(response),
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<Map<String, dynamic>>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Kayıt sil (DELETE)
  Future<ServiceResponse<bool>> delete({
    required String table,
    required Map<String, dynamic> filters,
  }) async {
    try {
      var query = client.from(table).delete();

      filters.forEach((key, value) {
        query = query.eq(key, value);
      });

      await query;
      return ServiceResponse.success(
        data: true,
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<bool>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// RPC (Remote Procedure Call) çağrısı
  Future<ServiceResponse<T>> rpc<T>({
    required String functionName,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await client.rpc(functionName, params: params);
      return ServiceResponse.success(
        data: response as T,
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<T>(
        error: e,
        statusCode: 500,
      );
    }
  }
}

