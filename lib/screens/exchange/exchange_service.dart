import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../domain/dtos/book_dto.dart';
import '../../domain/dtos/swap_dto.dart';

/// Exchange Service - Takas işlemleri servisi
class ExchangeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Karşı tarafın müsait kitaplarını getir
  Future<ServiceResponse<List<BookResponse>>> getOtherUserBooks(
      String userId) async {
    try {
      // Önce user_id'yi kontrol et
      if (userId.isEmpty) {
        return ServiceResponse.error(
          message: 'Kullanıcı ID boş',
          statusCode: 400,
        );
      }

      // Kitapları getir (users join'i olmadan - foreign key yok)
      final response = await _supabase
          .from('books')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      // Sonuçları filtrele: status NULL veya 'Müsait' olanlar
      final allBooks = (response as List)
          .map((item) => BookResponse.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      // Status filtresini Dart tarafında yap
      final books = allBooks.where((book) {
        return book.status == null ||
            book.status == 'Müsait' ||
            book.status!.isEmpty;
      }).toList();

      return ServiceResponse.success(
        data: books,
        message: 'Kullanıcının kitapları yüklendi (${books.length} adet)',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Kitaplar yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Kullanıcının kendi kitaplarını getir (takas için uygun olanlar)
  Future<ServiceResponse<List<BookResponse>>> getMyAvailableBooks() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Tüm kitapları getir
      final response = await _supabase
          .from('books')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      // Sonuçları filtrele: status NULL veya 'Müsait' olanlar
      final allBooks = (response as List)
          .map((item) => BookResponse.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      // Status filtresini Dart tarafında yap
      final books = allBooks.where((book) {
        return book.status == null ||
            book.status == 'Müsait' ||
            book.status!.isEmpty;
      }).toList();

      return ServiceResponse.success(
        data: books,
        message: 'Kitaplar yüklendi (${books.length} adet)',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Kitaplar yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Belirli bir kitabı getir
  Future<ServiceResponse<BookResponse>> getBook(String bookId) async {
    try {
      final response =
          await _supabase.from('books').select().eq('id', bookId).single();

      final book = BookResponse.fromJson(Map<String, dynamic>.from(response));

      return ServiceResponse.success(
        data: book,
        message: 'Kitap yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Kitap yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Takas önerisi oluştur
  Future<ServiceResponse<SwapResponse>> createSwapProposal(
      SwapRequest request) async {
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
            'owner_id': request.receiverId,
            'requested_book_id': request.requestedBookId,
            'offered_book_id': request.proposedBookId,
            'status': 'Beklemede',
            'message': request.message,
          })
          .select()
          .single();

      // Teklif edilen kitabın durumunu "Takasta" yap
      await _supabase
          .from('books')
          .update({'status': 'Takasta'}).eq('id', request.proposedBookId);

      // Chat'e takas mesajı gönder
      await _supabase.from('messages').insert({
        'sender_id': userId,
        'receiver_id': request.receiverId,
        'last_message': '📚 Takas önerisi gönderildi',
        'message_type': 'swap_proposal',
        'swap_proposal_id': response['id'].toString(),
      });

      final swap = SwapResponse.fromJson(Map<String, dynamic>.from(response));

      return ServiceResponse.success(
        data: swap,
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
          .eq('owner_id', userId);

      // Kitapların durumunu güncelle
      final swapData =
          await _supabase.from('book_swaps').select().eq('id', swapId).single();

      final requestedBookId = swapData['requested_book_id'].toString();
      final offeredBookId = swapData['offered_book_id'].toString();
      final requesterId = swapData['requester_id'].toString();

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

      // Takas bilgisini al
      final swapData =
          await _supabase.from('book_swaps').select().eq('id', swapId).single();

      final requesterId = swapData['requester_id'].toString();
      final offeredBookId = swapData['offered_book_id'].toString();

      // Takas önerisini güncelle
      await _supabase
          .from('book_swaps')
          .update({'status': 'Reddedildi'})
          .eq('id', swapId)
          .eq('owner_id', userId);

      // Teklif edilen kitabı tekrar "Müsait" yap
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

  /// Takas önerisini geri çek (sadece gönderen yapabilir)
  Future<ServiceResponse<bool>> withdrawSwapProposal(String swapId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      // Takas bilgisini al
      final swapData =
          await _supabase.from('book_swaps').select().eq('id', swapId).single();

      final ownerId = swapData['owner_id'].toString();
      final offeredBookId = swapData['offered_book_id'].toString();

      // Takas önerisini güncelle - sadece gönderen geri çekebilir
      await _supabase
          .from('book_swaps')
          .update({'status': 'İptal Edildi'})
          .eq('id', swapId)
          .eq('requester_id', userId);

      // Teklif edilen kitabı tekrar "Müsait" yap
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
        message: 'Takas önerisi geri çekildi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Takas önerisi geri çekilirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Takas detayını getir
  Future<ServiceResponse<SwapResponse>> getSwapDetail(String swapId) async {
    try {
      final response = await _supabase.from('book_swaps').select('''
            *,
            requested_book:requested_book_id(id, name, writer, image_url, type),
            offered_book:offered_book_id(id, name, writer, image_url, type)
          ''').eq('id', swapId).single();

      // Nested book verilerini düzelt
      final data = Map<String, dynamic>.from(response);

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
        requestedBook: data['requested_book'] != null
            ? BookResponse.fromJson(
                Map<String, dynamic>.from(data['requested_book']))
            : null,
        offeredBook: data['offered_book'] != null
            ? BookResponse.fromJson(
                Map<String, dynamic>.from(data['offered_book']))
            : null,
      );

      return ServiceResponse.success(
        data: swap,
        message: 'Takas detayı yüklendi',
        statusCode: 200,
      );
    } catch (e) {
      return ServiceResponse.error(
        message: 'Takas detayı yüklenirken hata oluştu: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Kullanıcının tüm takas önerilerini getir
  Future<ServiceResponse<List<SwapResponse>>> getMySwapProposals() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse.error(
          message: 'Kullanıcı giriş yapmamış',
          statusCode: 401,
        );
      }

      final response = await _supabase
          .from('book_swaps')
          .select('''
            *,
            requested_book:requested_book_id(id, name, writer, image_url),
            offered_book:offered_book_id(id, name, writer, image_url)
          ''')
          .or('requester_id.eq.$userId,owner_id.eq.$userId')
          .order('created_at', ascending: false);

      final swaps = (response as List).map((item) {
        final data = Map<String, dynamic>.from(item);
        return SwapResponse(
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
          requestedBook: data['requested_book'] != null
              ? BookResponse.fromJson(
                  Map<String, dynamic>.from(data['requested_book']))
              : null,
          offeredBook: data['offered_book'] != null
              ? BookResponse.fromJson(
                  Map<String, dynamic>.from(data['offered_book']))
              : null,
        );
      }).toList();

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
