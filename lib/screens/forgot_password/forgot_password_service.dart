import '../../base/models/service_response.dart';
import '../../base/services/error_handler.dart';
import '../../screens/login/login_service.dart';

/// Forgot Password Service - Şifre sıfırlama işlemleri
class ForgotPasswordService {
  final LoginService _loginService = LoginService();

  /// Şifre sıfırlama e-postası gönder
  Future<ServiceResponse<bool>> resetPassword(String email) async {
    try {
      return await _loginService.resetPassword(email);
    } catch (e) {
      return ErrorHandler.createErrorResponse<bool>(
        error: e,
        statusCode: 500,
      );
    }
  }
}

