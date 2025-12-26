import '../models/service_response.dart';
import '../../domain/dtos/auth_dto.dart';

/// Login Service Interface
abstract class ILoginService {
  /// Login işlemi
  Future<ServiceResponse<LoginResponse>> login(LoginRequest request);
  
  /// Şifre sıfırlama e-postası gönder
  Future<ServiceResponse<bool>> resetPassword(String email);
}
