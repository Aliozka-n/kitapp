import '../../base/models/service_response.dart';
import '../../base/services/error_handler.dart';
import '../../domain/dtos/user_dto.dart' as dto;
import '../../screens/profile/profile_service.dart';

/// Edit Profile Service - Profil düzenleme işlemleri
class EditProfileService {
  final ProfileService _profileService = ProfileService();

  /// Profil bilgilerini getir
  Future<ServiceResponse<dto.UserResponse>> getProfile() async {
    try {
      return await _profileService.getProfile();
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
      return await _profileService.updateProfile(request);
    } catch (e) {
      return ErrorHandler.createErrorResponse<dto.UserResponse>(
        error: e,
        statusCode: 500,
      );
    }
  }
}

