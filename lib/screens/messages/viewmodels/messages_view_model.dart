import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/message_dto.dart';
import '../../../domain/models/message_model.dart';
import '../messages_service.dart';

/// Messages ViewModel - Messages ekranının durum ve iş kuralları
class MessagesViewModel extends BaseViewModel {
  final MessagesService service;

  // PRIVATE FIELDS
  List<MessageResponse> _allMessages = [];
  String? _errorMessage;
  final Map<String, String> _userNamesCache = {}; // userId -> userName cache
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  // PUBLIC GETTERS
  List<MessageResponse> get messages => _getFilteredMessages();
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  /// Konuşmadaki diğer kullanıcının ID'si
  String? otherUserIdOf(MessageResponse message) {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return null;
    return message.senderId == currentUserId ? message.receiverId : message.senderId;
  }

  /// Konuşmadaki diğer kullanıcının adı (cache -> DTO fallback)
  String otherUserNameOf(MessageResponse message) {
    final otherUserId = otherUserIdOf(message);
    final cached = otherUserId != null ? _userNamesCache[otherUserId] : null;
    if (cached != null && cached.trim().isNotEmpty) return cached;

    final dtoName = message.userName;
    if (dtoName != null && dtoName.trim().isNotEmpty) return dtoName;

    return 'Kullanıcı';
  }

  // Constructor
  MessagesViewModel({required this.service});

  @override
  FutureOr<void> init() async {
    await loadMessages();
  }

  /// Messages yükle
  Future<void> loadMessages() async {
    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.getMessages();

      if (response.isSuccessful && response.data != null) {
        _allMessages = response.data!;

        // Kullanıcı adlarını cache'le
        await _loadUserNames();

        _errorMessage = null;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Mesajlar yüklenemedi';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Mesajlar yüklenirken hata oluştu';
      reloadState();
    } finally {
      isLoading = false;
    }
  }

  /// Kullanıcı adlarını yükle
  Future<void> _loadUserNames() async {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null) return;

    // Tüm unique kullanıcı ID'lerini topla
    final Set<String> userIds = {};
    for (final message in _allMessages) {
      if (message.senderId != null && message.senderId != currentUserId) {
        userIds.add(message.senderId!);
      }
      if (message.receiverId != null && message.receiverId != currentUserId) {
        userIds.add(message.receiverId!);
      }
    }

    // Her kullanıcı için adını çek
    for (final userId in userIds) {
      if (!_userNamesCache.containsKey(userId)) {
        try {
          final userResponse = await service.getUserInfo(userId);
          if (userResponse.isSuccessful && userResponse.data != null) {
            final userName = userResponse.data!['name'] as String?;
            if (userName != null) {
              _userNamesCache[userId] = userName;
            }
          }
        } catch (e) {
          // Sessizce geç
        }
      }
    }
  }

  /// Arama sorgusunu güncelle
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    reloadState();
  }

  /// Arama sorgusunu temizle
  void clearSearch() {
    _searchQuery = '';
    searchController.clear();
    reloadState();
  }

  /// Filtrelenmiş mesajları getir
  List<MessageResponse> _getFilteredMessages() {
    final groupedMessages = _getGroupedMessages();

    if (_searchQuery.isEmpty) {
      return groupedMessages;
    }

    // Kullanıcı adı veya son mesaj içinde arama yap
    return groupedMessages.where((message) {
      final userName = otherUserNameOf(message).toLowerCase();
      final lastMessage = (message.lastMessage ?? '').toLowerCase();
      return userName.contains(_searchQuery) ||
          lastMessage.contains(_searchQuery);
    }).toList();
  }

  /// Mesajları kullanıcı bazında grupla ve son mesajı al
  List<MessageResponse> _getGroupedMessages() {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return [];

    // Kullanıcı ID'sine göre mesajları grupla
    final Map<String, MessageResponse> groupedMessages = {};

    for (final message in _allMessages) {
      // Diğer kullanıcının ID'sini bul
      final otherUserId = otherUserIdOf(message);

      if (otherUserId == null) continue;

      // Bu kullanıcıyla olan son mesajı bul
      if (!groupedMessages.containsKey(otherUserId)) {
        groupedMessages[otherUserId] = message;
      } else {
        final existingMessage = groupedMessages[otherUserId]!;
        // Daha yeni mesajı al
        if (message.createdAt != null &&
            existingMessage.createdAt != null &&
            message.createdAt!.isAfter(existingMessage.createdAt!)) {
          groupedMessages[otherUserId] = message;
        }
      }
    }

    // Son mesajlara göre sırala (en yeni üstte)
    final sortedMessages = groupedMessages.values.toList();
    sortedMessages.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });

    return sortedMessages;
  }

  /// MessageResponse'u MessageModel'e çevir (mevcut widget'lar için)
  MessageModel? toMessageModel(MessageResponse message) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    // Diğer kullanıcının ID'sini bul
    final otherUserId = message.senderId == currentUserId
        ? message.receiverId
        : message.senderId;

    // Diğer kullanıcının adını cache'den al
    String? userName;
    if (otherUserId != null) {
      userName = _userNamesCache[otherUserId];
    }

    // Eğer cache'de yoksa, message'daki userName'i kullan (fallback)
    if (userName == null || userName.isEmpty) {
      userName = message.userName ?? 'Kullanıcı';
    }

    return MessageModel(
      userName: userName,
      lastMessage: message.lastMessage,
      date: message.date ?? message.createdAt?.toString() ?? '',
    );
  }

  /// Mesaj sil
  Future<bool> deleteMessage(String messageId) async {
    isLoading = true;
    _errorMessage = null;
    reloadState();

    try {
      final response = await service.deleteMessage(messageId);

      if (response.isSuccessful) {
        // Listeden kaldır
        _allMessages.removeWhere((msg) => msg.id == messageId);
        reloadState();
        isLoading = false;
        return true;
      } else {
        _errorMessage = response.message ?? 'Mesaj silinemedi';
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Mesaj silinirken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
