import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_response.dart';

/// Swap Service - Supabase ile takas önerileri işlemleri
class SwapService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Takas önerisi oluştur
  Future<ServiceResponse<Map<String, dynamic>>> createSwapProposal({
    required String receiverId,
    required String proposedBookId,
    required String requestedBookId,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Takas önerisi oluştur
      final response = await _supabase
          .from('book_swaps')
          .insert({
            'requester_id': userId,
            'owner_id': receiverId,
            'requested_book_id': requestedBookId,
            'offered_book_id': proposedBookId,
            'status': 'Beklemede',
          })
          .select()
          .single();

      // Mesaj gönder (takas önerisi mesajı)
      await _supabase.from('messages').insert({
        'sender_id': userId,
        'receiver_id': receiverId,
        'last_message': 'Takas önerisi gönderildi',
        'message_type': 'swap_proposal',
        'swap_proposal_id': response['id'].toString(),
      });

      return ServiceResponse.success(
        data: Map<String, dynamic>.from(response),
        message: 'Takas önerisi gönderildi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Takas önerisi oluşturulurken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Takas önerisini kabul et
  Future<ServiceResponse<bool>> acceptSwapProposal(String swapId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Takas önerisini güncelle
      await _supabase
          .from('book_swaps')
          .update({'status': 'Kabul Edildi'})
          .eq('id', swapId)
          .eq('owner_id', userId); // Sadece owner kabul edebilir

      // Kitapların durumunu güncelle
      final swapData = await _supabase
          .from('book_swaps')
          .select()
          .eq('id', swapId)
          .single();

      // Her iki kitabın durumunu güncelle
      final requestedBookId = swapData['requested_book_id'].toString();
      final offeredBookId = swapData['offered_book_id'].toString();
      
      await _supabase
          .from('books')
          .update({'status': 'Takas Edildi'})
          .eq('id', requestedBookId);
      
      await _supabase
          .from('books')
          .update({'status': 'Takas Edildi'})
          .eq('id', offeredBookId);

      return ServiceResponse.success(
        data: true,
        message: 'Takas önerisi kabul edildi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Takas önerisi kabul edilirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Takas önerisini reddet
  Future<ServiceResponse<bool>> rejectSwapProposal(String swapId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Takas önerisini güncelle
      await _supabase
          .from('book_swaps')
          .update({'status': 'Reddedildi'})
          .eq('id', swapId)
          .eq('owner_id', userId); // Sadece owner reddedebilir

      return ServiceResponse.success(
        data: true,
        message: 'Takas önerisi reddedildi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Takas önerisi reddedilirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Kullanıcının takas önerilerini getir
  Future<ServiceResponse<List<Map<String, dynamic>>>> getSwapProposals() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Kullanıcının gönderdiği ve aldığı takas önerilerini getir
      final response = await _supabase
          .from('book_swaps')
          .select()
          .or('requester_id.eq.$userId,owner_id.eq.$userId')
          .order('created_at', ascending: false);

      final swaps = (response as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      return ServiceResponse.success(
        data: swaps,
        message: 'Takas önerileri yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Takas önerileri yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}

