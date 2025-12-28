import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../domain/dtos/message_dto.dart';
import '../../domain/dtos/swap_dto.dart';
import '../../domain/dtos/book_dto.dart';

/// Chat Detail Service - Supabase ile chat detay işlemleri
class ChatDetailService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Belirli bir kullanıcı ile olan mesajları getir (son 20 mesaj)
  Future<ServiceResponse<List<MessageResponse>>> getChatMessages(
      String otherUserId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // İki kullanıcı arasındaki mesajları getir (son 20 mesaj)
      // İki ayrı sorgu yapıp birleştir (daha güvenilir)
      final sentMessages = await _supabase
          .from('messages')
          .select()
          .eq('sender_id', userId)
          .eq('receiver_id', otherUserId)
          .order('created_at', ascending: false)
          .limit(20);

      final receivedMessages = await _supabase
          .from('messages')
          .select()
          .eq('sender_id', otherUserId)
          .eq('receiver_id', userId)
          .order('created_at', ascending: false)
          .limit(20);

      // İki listeyi birleştir
      final allMessages = <Map<String, dynamic>>[];
      allMessages.addAll(
          (sentMessages as List).map((e) => Map<String, dynamic>.from(e)));
      allMessages.addAll(
          (receivedMessages as List).map((e) => Map<String, dynamic>.from(e)));

      // Tarihe göre sırala ve son 20'yi al
      allMessages.sort((a, b) {
        final aDate = a['created_at'];
        final bDate = b['created_at'];
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        try {
          final aDateTime =
              aDate is DateTime ? aDate : DateTime.parse(aDate.toString());
          final bDateTime =
              bDate is DateTime ? bDate : DateTime.parse(bDate.toString());
          return bDateTime.compareTo(aDateTime);
        } catch (e) {
          return 0;
        }
      });

      final filteredMessages = allMessages.take(20).toList();

      final messages = filteredMessages
          .map((item) => MessageResponse.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();

      // Mesajları ters çevir (en eski en üstte, en yeni en altta)
      final reversedMessages = messages.reversed.toList();

      return ServiceResponse.success(
        data: reversedMessages,
        message: 'Mesajlar yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Mesajlar yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Mesaj gönder
  Future<ServiceResponse<MessageResponse>> sendMessage(
      MessageRequest request) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Mesaj verisini hazırla - date alanını kaldır, Supabase otomatik created_at oluşturur
      final messageData = {
        'user_name': request.userName,
        'last_message': request.lastMessage,
        'receiver_id': request.receiverId,
        'sender_id': userId,
        // 'is_read': false, // Bu kolon veritabanında yok
        if (request.messageType != null) 'message_type': request.messageType,
        if (request.swapProposalId != null)
          'swap_proposal_id': request.swapProposalId,
      };

      final response = await _supabase
          .from('messages')
          .insert(messageData)
          .select()
          .single();

      final message = MessageResponse.fromJson(
        Map<String, dynamic>.from(response),
      );

      return ServiceResponse.success(
        data: message,
        message: 'Mesaj gönderildi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Mesaj gönderilirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Kullanıcı bilgilerini getir
  Future<ServiceResponse<Map<String, dynamic>>> getUserInfo(
      String userId) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', userId).single();

      return ServiceResponse.success(
        data: Map<String, dynamic>.from(response),
        message: 'Kullanıcı bilgisi yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Kullanıcı bilgisi yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Swap detaylarını getir
  Future<ServiceResponse<SwapResponse>> getSwapDetail(String swapId) async {
    try {
      final response =
          await _supabase.from('book_swaps').select().eq('id', swapId).single();

      final data = Map<String, dynamic>.from(response);

      // Kitap bilgilerini ayrı ayrı çek
      BookResponse? offeredBook;
      BookResponse? requestedBook;

      if (data['offered_book_id'] != null) {
        final bookResponse = await _supabase
            .from('books')
            .select()
            .eq('id', data['offered_book_id'])
            .maybeSingle();
        if (bookResponse != null) {
          offeredBook =
              BookResponse.fromJson(Map<String, dynamic>.from(bookResponse));
        }
      }

      if (data['requested_book_id'] != null) {
        final bookResponse = await _supabase
            .from('books')
            .select()
            .eq('id', data['requested_book_id'])
            .maybeSingle();
        if (bookResponse != null) {
          requestedBook =
              BookResponse.fromJson(Map<String, dynamic>.from(bookResponse));
        }
      }

      final swap = SwapResponse(
        id: data['id']?.toString(),
        requesterId: data['requester_id']?.toString(),
        ownerId: data['owner_id']?.toString(),
        requestedBookId: data['requested_book_id']?.toString(),
        offeredBookId: data['offered_book_id']?.toString(),
        status: SwapResponse.fromJson(data).status,
        message: data['message'],
        createdAt: data['created_at'] != null
            ? DateTime.parse(data['created_at'])
            : null,
        offeredBook: offeredBook,
        requestedBook: requestedBook,
      );

      return ServiceResponse.success(
        data: swap,
        message: 'Swap detayı yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Swap detayı yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Swap teklifini kabul et
  Future<ServiceResponse<bool>> acceptSwapProposal(String swapId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Swap bilgisini al
      final swapData =
          await _supabase.from('book_swaps').select().eq('id', swapId).single();

      final requestedBookId = swapData['requested_book_id'].toString();
      final offeredBookId = swapData['offered_book_id'].toString();
      final requesterId = swapData['requester_id'].toString();

      // Swap durumunu güncelle
      await _supabase
          .from('book_swaps')
          .update({'status': 'Kabul Edildi'})
          .eq('id', swapId)
          .eq('owner_id', userId);

      // Her iki kitabı da "Takas Edildi" yap
      await _supabase
          .from('books')
          .update({'status': 'Takas Edildi'}).eq('id', requestedBookId);

      await _supabase
          .from('books')
          .update({'status': 'Takas Edildi'}).eq('id', offeredBookId);

      // Bildirim mesajı gönder
      await _supabase.from('messages').insert({
        'sender_id': userId,
        'receiver_id': requesterId,
        'last_message': '✅ Takas teklifiniz kabul edildi!',
        'message_type': 'swap_accepted',
        'swap_proposal_id': swapId,
      });

      return ServiceResponse.success(
        data: true,
        message: 'Swap kabul edildi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Swap kabul edilirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Swap teklifini reddet
  Future<ServiceResponse<bool>> rejectSwapProposal(String swapId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Swap bilgisini al
      final swapData =
          await _supabase.from('book_swaps').select().eq('id', swapId).single();

      final offeredBookId = swapData['offered_book_id'].toString();
      final requesterId = swapData['requester_id'].toString();

      // Swap durumunu güncelle
      await _supabase
          .from('book_swaps')
          .update({'status': 'Reddedildi'})
          .eq('id', swapId)
          .eq('owner_id', userId);

      // Teklif edilen kitabı "Müsait" yap
      await _supabase
          .from('books')
          .update({'status': 'Müsait'}).eq('id', offeredBookId);

      // Bildirim mesajı gönder
      await _supabase.from('messages').insert({
        'sender_id': userId,
        'receiver_id': requesterId,
        'last_message': '❌ Takas teklifiniz reddedildi',
        'message_type': 'swap_rejected',
        'swap_proposal_id': swapId,
      });

      return ServiceResponse.success(
        data: true,
        message: 'Swap reddedildi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Swap reddedilirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Swap teklifini geri çek
  Future<ServiceResponse<bool>> withdrawSwapProposal(String swapId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Swap bilgisini al
      final swapData =
          await _supabase.from('book_swaps').select().eq('id', swapId).single();

      final offeredBookId = swapData['offered_book_id'].toString();
      final ownerId = swapData['owner_id'].toString();

      // Swap durumunu güncelle - sadece gönderen çekebilir
      await _supabase
          .from('book_swaps')
          .update({'status': 'İptal Edildi'})
          .eq('id', swapId)
          .eq('requester_id', userId);

      // Teklif edilen kitabı "Müsait" yap
      await _supabase
          .from('books')
          .update({'status': 'Müsait'}).eq('id', offeredBookId);

      // Bildirim mesajı gönder
      await _supabase.from('messages').insert({
        'sender_id': userId,
        'receiver_id': ownerId,
        'last_message': '🚫 Takas teklifi geri çekildi',
        'message_type': 'swap_withdrawn',
        'swap_proposal_id': swapId,
      });

      return ServiceResponse.success(
        data: true,
        message: 'Swap geri çekildi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Swap geri çekilirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
