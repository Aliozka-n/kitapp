import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/message_dto.dart';
import '../chat_detail_service.dart';

/// Chat Detail ViewModel - Chat detail ekranının durum ve iş kuralları
class ChatDetailViewModel extends BaseViewModel {
  final ChatDetailService service;
  final String receiverId;
  final String receiverName;

  // PRIVATE FIELDS
  List<MessageResponse> _messages = [];
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String? _errorMessage;
  String? _receiverEmail;

  // PUBLIC GETTERS
  List<MessageResponse> get messages => _messages;
  String? get errorMessage => _errorMessage;
  String? get receiverEmail => _receiverEmail;
  bool get hasSwapProposal => false; // TODO: Implement swap proposal check
  String? get currentUserId => Supabase.instance.client.auth.currentUser?.id;

  // Constructor
  ChatDetailViewModel({
    required this.service,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  FutureOr<void> init() async {
    await loadMessages();
    await loadReceiverInfo();
  }

  /// Ekran ilk açıldığında ve yeni mesaj eklendiğinde listeyi en alta kaydır.
  /// `ListView(reverse: false)` için en alt = maxScrollExtent.
  void scrollToBottom({bool animated = true}) {
    void tryScroll(int attempt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) {
          if (attempt < 2) tryScroll(attempt + 1);
          return;
        }

        final target = scrollController.position.maxScrollExtent;
        if (animated) {
          scrollController.animateTo(
            target,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        } else {
          scrollController.jumpTo(target);
        }
      });
    }

    tryScroll(0);
  }

  /// Messages yükle
  Future<void> loadMessages() async {
    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.getChatMessages(receiverId);

      if (response.isSuccessful && response.data != null) {
        _messages = response.data!;
        _errorMessage = null;
        reloadState();

        // Mesajlar yüklendikten sonra en alta scroll et
        scrollToBottom(animated: false);
      } else {
        _errorMessage = response.message ?? 'Mesajlar yüklenemedi';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Mesajlar yüklenirken hata oluştu: ${e.toString()}';
      reloadState();
    } finally {
      isLoading = false;
    }
  }

  /// Receiver bilgilerini yükle
  Future<void> loadReceiverInfo() async {
    try {
      final response = await service.getUserInfo(receiverId);
      if (response.isSuccessful && response.data != null) {
        _receiverEmail = response.data!['email'] as String?;
        reloadState();
      }
    } catch (e) {
      // Hata durumunda sessizce geç
    }
  }

  /// Mesaj gönder
  Future<bool> sendMessage() async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty) {
      return false;
    }

    // Mesajı optimistik olarak ekle (UI'da hemen göster)
    final optimisticMessage = MessageResponse(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      userName: receiverName,
      lastMessage: messageText,
      senderId: Supabase.instance.client.auth.currentUser?.id,
      receiverId: receiverId,
      createdAt: DateTime.now(),
      date: DateTime.now().toIso8601String(),
      isRead: false,
      messageType: 'text',
    );

    // UI'ı hemen güncelle - isLoading yapmadan önce
    // Yeni liste referansı oluştur (Flutter'ın değişikliği algılaması için)
    _messages = [..._messages, optimisticMessage];
    messageController.clear();
    // reloadState() yerine direkt notifyListeners() çağır çünkü isLoading false
    if (!isDisposed) {
      notifyListeners();
    }
    scrollToBottom(animated: true);

    _errorMessage = null;
    isLoading = true;

    try {
      // userName: receiver'ın adı (mesaj listesinde gösterilecek)
      final request = MessageRequest(
        userName:
            receiverName, // Alıcının adı (messages listesinde gösterilecek)
        lastMessage: messageText,
        receiverId: receiverId,
        date: DateTime.now().toIso8601String(),
      );

      final response = await service.sendMessage(request);

      if (response.isSuccessful && response.data != null) {
        // Optimistik mesajı kaldır ve gerçek mesajı ekle - yeni liste referansı oluştur
        final filteredMessages =
            _messages.where((m) => m.id != optimisticMessage.id).toList();
        filteredMessages.add(response.data!);
        _messages = filteredMessages;
        _errorMessage = null;
        isLoading = false;
        // isLoading false olduğu için reloadState() çalışacak, ama garantili olması için notifyListeners() da çağır
        if (!isDisposed) {
          notifyListeners();
        }
        // Scroll işlemini biraz geciktir
        scrollToBottom(animated: true);
        return true;
      } else {
        // Hata durumunda optimistik mesajı kaldır - yeni liste referansı oluştur
        _messages =
            _messages.where((m) => m.id != optimisticMessage.id).toList();
        _errorMessage = response.message ?? 'Mesaj gönderilemedi';
        isLoading = false;
        if (!isDisposed) {
          notifyListeners();
        }
        return false;
      }
    } catch (e) {
      // Hata durumunda optimistik mesajı kaldır - yeni liste referansı oluştur
      _messages = _messages.where((m) => m.id != optimisticMessage.id).toList();
      _errorMessage = 'Mesaj gönderilirken hata oluştu: ${e.toString()}';
      isLoading = false;
      if (!isDisposed) {
        notifyListeners();
      }
      return false;
    }
  }

  /// Kullanıcının gönderdiği mesaj mı kontrol et
  bool isMyMessage(MessageResponse message) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    return message.senderId == userId;
  }

  /// Mesajları yeniden yükle (Pull to Refresh için)
  Future<void> refresh() async {
    await Future.wait([
      loadMessages(),
      loadReceiverInfo(),
    ]);
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
