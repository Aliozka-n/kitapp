import '../models/service_response.dart';
import '../../domain/dtos/message_dto.dart';

/// Messages Service Interface
abstract class IMessagesService {
  /// Message listesi getir
  Future<ServiceResponse<List<MessageResponse>>> getMessages();

  /// Kullanıcı bilgisini getir
  Future<ServiceResponse<Map<String, dynamic>>> getUserInfo(String userId);

  /// Mesajı okundu olarak işaretle
  Future<ServiceResponse<bool>> markAsRead(String messageId);

  /// Mesajı sil
  Future<ServiceResponse<bool>> deleteMessage(String messageId);
}

