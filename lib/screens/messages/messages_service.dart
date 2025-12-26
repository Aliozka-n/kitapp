import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../base/services/error_handler.dart';
import '../../base/services/i_messages_service.dart';
import '../../domain/dtos/message_dto.dart';

/// Messages Service - Supabase ile mesaj listesi işlemleri
class MessagesService implements IMessagesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Message listesi getir (kullanıcının gönderdiği ve aldığı mesajlar)
  Future<ServiceResponse<List<MessageResponse>>> getMessages() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Kullanıcının gönderdiği veya aldığı mesajları getir
      // Her konuşmanın son mesajını almak için distinct kullan
      final response = await _supabase
          .from('messages')
          .select()
          .or('sender_id.eq.$userId,receiver_id.eq.$userId')
          .order('created_at', ascending: false);

      final messages = (response as List)
          .map((item) {
            final messageData = Map<String, dynamic>.from(item);
            
            // Diğer kullanıcının ID'sini bul
            final otherUserId = messageData['sender_id'] == userId
                ? messageData['receiver_id']
                : messageData['sender_id'];
            
            // Eğer userName yoksa, users tablosundan çek
            if (messageData['user_name'] == null && otherUserId != null) {
              // Burada user bilgisini çekmek için ayrı bir sorgu gerekebilir
              // Şimdilik mevcut user_name'i kullan
            }
            
            return MessageResponse.fromJson(messageData);
          })
          .toList();

      return ServiceResponse.success(
        data: messages,
        message: 'Mesajlar yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<List<MessageResponse>>(
        error: e,
        statusCode: 500,
      );
    }
  }
  
  /// Kullanıcı bilgisini getir
  Future<ServiceResponse<Map<String, dynamic>>> getUserInfo(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id, name, email, avatar_url')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı bulunamadı',
          statusCode: 404,
        );
      }

      return ServiceResponse.success(
        data: Map<String, dynamic>.from(response),
        message: 'Kullanıcı bilgisi yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<Map<String, dynamic>>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Mesajı okundu olarak işaretle
  Future<ServiceResponse<bool>> markAsRead(String messageId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      await _supabase
          .from('messages')
          .update({'is_read': true})
          .eq('id', messageId)
          .eq('receiver_id', userId);

      return ServiceResponse.success(
        data: true,
        message: 'Mesaj okundu olarak işaretlendi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<bool>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Mesajı sil (sadece kendi mesajını silebilir)
  Future<ServiceResponse<bool>> deleteMessage(String messageId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Sadece kendi mesajını silebilir
      await _supabase
          .from('messages')
          .delete()
          .eq('id', messageId)
          .eq('sender_id', userId);

      return ServiceResponse.success(
        data: true,
        message: 'Mesaj silindi',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<bool>(
        error: e,
        statusCode: 500,
      );
    }
  }
}

