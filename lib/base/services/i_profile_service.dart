import '../models/service_response.dart';
import '../../domain/dtos/user_dto.dart' as dto;

/// Profile Service Interface
abstract class IProfileService {
  /// Profil bilgilerini getir
  Future<ServiceResponse<dto.UserResponse>> getProfile();

  /// Profil güncelle
  Future<ServiceResponse<dto.UserResponse>> updateProfile(
      dto.UserRequest request);

  /// Logout işlemi
  Future<ServiceResponse<void>> logout();

  /// Paylaşılan kitap sayısını getir
  Future<ServiceResponse<int>> getSharedBooksCount();

  /// Takas edilen kitap sayısını getir
  Future<ServiceResponse<int>> getSwappedBooksCount();

  /// Şu anda paylaşılan kitapları getir
  Future<ServiceResponse<List<Map<String, dynamic>>>> getCurrentlySharedBooks();
}
