import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/network_config.dart';
import '../models/service_response.dart';

/// Request Type Enum
enum RequestType {
  get,
  post,
  put,
  delete,
  patch,
}

/// Network Service - Singleton pattern ile HTTP işlemleri
class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  /// Default headers - Supabase için gerekli header'lar
  Future<Map<String, String>> get _defaultHeaders async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Supabase anon key ekle
    final anonKey = NetworkConfig().supabaseAnonKey;
    if (anonKey != null) {
      headers['apikey'] = anonKey;
    }

    // Eğer kullanıcı giriş yaptıysa, access token'ı ekle
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      headers['Authorization'] = 'Bearer ${session.accessToken}';
    }

    return headers;
  }

  /// HTTP isteği yap
  Future<ServiceResponse<dynamic>> makeRequest(
    String url, {
    RequestType type = RequestType.get,
    Map<String, String>? headers,
    String? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Headers'ı birleştir
      final defaultHeaders = await _defaultHeaders;
      final requestHeaders = {
        ...defaultHeaders,
        if (headers != null) ...headers,
      };

      // Query parameters ekle
      String finalUrl = url;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        final uri = Uri.parse(url);
        final newUri = uri.replace(
          queryParameters: {
            ...uri.queryParameters,
            ...queryParameters.map((key, value) => MapEntry(key, value.toString())),
          },
        );
        finalUrl = newUri.toString();
      }

      http.Response response;

      // Request type'a göre istek yap
      switch (type) {
        case RequestType.get:
          response = await http.get(
            Uri.parse(finalUrl),
            headers: requestHeaders,
          );
          break;
        case RequestType.post:
          response = await http.post(
            Uri.parse(finalUrl),
            headers: requestHeaders,
            body: body,
          );
          break;
        case RequestType.put:
          response = await http.put(
            Uri.parse(finalUrl),
            headers: requestHeaders,
            body: body,
          );
          break;
        case RequestType.delete:
          response = await http.delete(
            Uri.parse(finalUrl),
            headers: requestHeaders,
          );
          break;
        case RequestType.patch:
          response = await http.patch(
            Uri.parse(finalUrl),
            headers: requestHeaders,
            body: body,
          );
          break;
      }

      // Response'u parse et
      return _handleResponse(response);
    } catch (e) {
      return ServiceResponse.error(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Response'u handle et
  ServiceResponse<dynamic> _handleResponse(http.Response response) {
    try {
      final statusCode = response.statusCode;
      final responseBody = response.body;

      if (statusCode >= 200 && statusCode < 300) {
        // Başarılı response
        dynamic data;
        if (responseBody.isNotEmpty) {
          try {
            data = json.decode(responseBody);
          } catch (e) {
            data = responseBody;
          }
        }

        return ServiceResponse.success(
          data: data,
          statusCode: statusCode,
        );
      } else {
        // Hata response
        String? errorMessage;
        try {
          final errorData = json.decode(responseBody);
          errorMessage = errorData['message'] ?? errorData['error'] ?? 'An error occurred';
        } catch (e) {
          errorMessage = responseBody.isNotEmpty ? responseBody : 'An error occurred';
        }

        return ServiceResponse.error(
          message: errorMessage,
          statusCode: statusCode,
        );
      }
    } catch (e) {
      return ServiceResponse.error(
        message: 'Response parsing error: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }
}

