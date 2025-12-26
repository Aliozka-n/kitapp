import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../domain/dtos/auth_dto.dart';
import '../../domain/dtos/user_dto.dart' as dto;

/// Register Service - Supabase Auth ile kayıt işlemleri
class RegisterService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Register işlemi - Supabase Auth kullanarak
  Future<ServiceResponse<RegisterResponse>> register(
      RegisterRequest request) async {
    try {
      // Supabase Auth ile kullanıcı kaydı
      // Email confirmation'ı devre dışı bırakmak için emailRedirectTo ekleniyor
      final response = await _supabase.auth.signUp(
        email: request.email,
        password: request.password,
        data: {
          'name': request.name,
          'il': request.il,
          'ilce': request.ilce,
        },
        emailRedirectTo: null, // Email confirmation'ı atla
      );

      if (response.user != null) {
        // User profile'ı güncelle (trigger otomatik oluşturur, ama güncelleme yapalım)
        try {
          await _supabase.from('users').update({
            'name': request.name,
            if (request.il != null) 'il': request.il,
            if (request.ilce != null) 'ilce': request.ilce,
          }).eq('id', response.user!.id);
        } catch (e) {
          // Profile henüz oluşmamış olabilir, hata yok say
        }

        // Session token'ı al (email confirmation açıksa session null olabilir)
        final session = response.session;
        final token = session?.accessToken;

        // User bilgilerini al
        final userResponse = dto.UserResponse(
          id: response.user?.id,
          name: request.name,
          email: request.email,
          il: request.il,
          ilce: request.ilce,
          createdAt: response.user?.createdAt != null
              ? DateTime.parse(response.user!.createdAt)
              : null,
        );

        // Email confirmation açıksa, kullanıcıya bilgi ver
        if (session == null) {
          return ServiceResponse.success(
            data: RegisterResponse(
              token: null,
              user: userResponse,
            ),
            message: 'Kayıt başarılı! Lütfen email adresinizi kontrol edin ve doğrulama linkine tıklayın.',
            statusCode: 200,
          );
        }

        return ServiceResponse.success(
          data: RegisterResponse(
            token: token ?? '',
            user: userResponse,
          ),
          message: 'Kayıt başarılı',
          statusCode: 200,
        );
      } else {
        return ServiceResponse.error(
          message: 'Kayıt başarısız',
          statusCode: 400,
        );
      }
    } on AuthException catch (e) {
      return ServiceResponse.error(
        message: e.message.isNotEmpty ? e.message : 'Kayıt olurken hata oluştu',
        statusCode: 400,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Kayıt olurken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
