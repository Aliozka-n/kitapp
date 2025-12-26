import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../base/services/error_handler.dart';
import '../../base/services/i_login_service.dart';
import '../../domain/dtos/auth_dto.dart';
import '../../domain/dtos/user_dto.dart' as dto;

/// Login Service - Supabase Auth ile giriş işlemleri
class LoginService implements ILoginService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Login işlemi - Supabase Auth kullanarak
  Future<ServiceResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      // Supabase Auth ile giriş
      final response = await _supabase.auth.signInWithPassword(
        email: request.email,
        password: request.password,
      );

      if (response.user != null && response.session != null) {
        // User profile bilgilerini al
        dto.UserResponse? userResponse;
        try {
          final userProfile = await _supabase
              .from('users')
              .select()
              .eq('id', response.user!.id)
              .single();

          userResponse = dto.UserResponse.fromJson(
            Map<String, dynamic>.from(userProfile),
          );
        } catch (e) {
          // Profile bulunamadı, auth user'dan oluştur
          final metadata = response.user?.userMetadata ?? {};
          userResponse = dto.UserResponse(
            id: response.user?.id,
            name: metadata['name'],
            email: response.user?.email,
            il: metadata['il'],
            ilce: metadata['ilce'],
            createdAt: response.user?.createdAt != null
                ? DateTime.parse(response.user!.createdAt)
                : null,
          );
        }

        // expiresAt'i DateTime'a çevir
        DateTime? expiresAt;
        final expiresAtSeconds = response.session?.expiresAt;
        if (expiresAtSeconds != null) {
          expiresAt = DateTime.fromMillisecondsSinceEpoch(
            expiresAtSeconds * 1000,
          );
        }

        return ServiceResponse.success(
          data: LoginResponse(
            token: response.session?.accessToken ?? '',
            refreshToken: response.session?.refreshToken ?? '',
            user: userResponse,
            expiresAt: expiresAt,
          ),
          message: 'Giriş başarılı',
          statusCode: 200,
        );
      } else {
        return ServiceResponse.error(
          message: 'Giriş başarısız',
          statusCode: 400,
        );
      }
    } on AuthException catch (e) {
      return ErrorHandler.createErrorResponse<LoginResponse>(
        error: e,
        statusCode: 401,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<LoginResponse>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Şifre sıfırlama e-postası gönder
  Future<ServiceResponse<bool>> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: null, // Supabase dashboard'dan ayarlanmalı
      );

      return ServiceResponse.success(
        data: true,
        message: 'Şifre sıfırlama e-postası gönderildi',
        statusCode: 200,
      );
    } on AuthException catch (e) {
      return ErrorHandler.createErrorResponse<bool>(
        error: e,
        statusCode: 400,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<bool>(
        error: e,
        statusCode: 500,
      );
    }
  }
}
