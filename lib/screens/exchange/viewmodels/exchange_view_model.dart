import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/book_dto.dart';
import '../../../domain/dtos/swap_dto.dart';
import '../exchange_service.dart';

/// Exchange ViewModel - Quantum Takas ekranı için durum yönetimi
/// 
/// Dual Selection: Her iki taraftan da kitap seçilebilir
class ExchangeViewModel extends BaseViewModel {
  final ExchangeService service;
  final String otherUserId; // Karşı tarafın ID'si
  final String otherUserName; // Karşı tarafın adı

  // PRIVATE FIELDS - Benim kitaplarım
  List<BookResponse> _myBooks = [];
  BookResponse? _selectedMyBook;

  // PRIVATE FIELDS - Karşı tarafın kitapları
  List<BookResponse> _otherUserBooks = [];
  BookResponse? _selectedOtherBook;

  // Ortak alanlar
  String? _errorMessage;
  bool _swapSuccess = false;
  SwapResponse? _createdSwap;

  // Controller
  final TextEditingController messageController = TextEditingController();

  // PUBLIC GETTERS - Benim kitaplarım
  List<BookResponse> get myBooks => _myBooks;
  BookResponse? get selectedMyBook => _selectedMyBook;

  // PUBLIC GETTERS - Karşı tarafın kitapları
  List<BookResponse> get otherUserBooks => _otherUserBooks;
  BookResponse? get selectedOtherBook => _selectedOtherBook;

  // Ortak getters
  String? get errorMessage => _errorMessage;
  bool get swapSuccess => _swapSuccess;
  SwapResponse? get createdSwap => _createdSwap;
  String? get currentUserId => Supabase.instance.client.auth.currentUser?.id;

  /// Takas teklifi gönderilebilir mi?
  bool get canSendProposal => _selectedMyBook != null && _selectedOtherBook != null;

  /// Constructor
  ExchangeViewModel({
    required this.service,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  FutureOr<void> init() async {
    await Future.wait([
      loadMyBooks(),
      loadOtherUserBooks(),
    ]);
  }

  /// Kullanıcının takas için uygun kitaplarını yükle
  Future<void> loadMyBooks() async {
    try {
      final response = await service.getMyAvailableBooks();

      if (response.isSuccessful && response.data != null) {
        _myBooks = response.data!;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Kitaplarınız yüklenemedi';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Kitaplar yüklenirken hata oluştu';
      reloadState();
    }
  }

  /// Karşı tarafın müsait kitaplarını yükle
  Future<void> loadOtherUserBooks() async {
    try {
      // Debug log
      debugPrint('🔍 Loading books for otherUserId: $otherUserId');
      
      final response = await service.getOtherUserBooks(otherUserId);

      // Debug log
      debugPrint('📚 Response: ${response.isSuccessful}, Books count: ${response.data?.length ?? 0}');
      debugPrint('📝 Message: ${response.message}');

      if (response.isSuccessful && response.data != null) {
        _otherUserBooks = response.data!;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Karşı tarafın kitapları yüklenemedi';
        reloadState();
      }
    } catch (e) {
      debugPrint('❌ Error loading other user books: $e');
      _errorMessage = 'Kitaplar yüklenirken hata oluştu: $e';
      reloadState();
    }
  }

  /// Benim kitabımı seç
  void selectMyBook(BookResponse book) {
    _selectedMyBook = book;
    reloadState();
  }

  /// Benim seçimimi temizle
  void clearMySelection() {
    _selectedMyBook = null;
    reloadState();
  }

  /// Karşı tarafın kitabını seç
  void selectOtherBook(BookResponse book) {
    _selectedOtherBook = book;
    reloadState();
  }

  /// Karşı taraf seçimini temizle
  void clearOtherSelection() {
    _selectedOtherBook = null;
    reloadState();
  }

  /// Takas önerisi gönder
  Future<bool> sendSwapProposal() async {
    if (!canSendProposal) {
      _errorMessage = 'Lütfen her iki taraftan da kitap seçin';
      reloadState();
      return false;
    }

    isLoading = true;
    _errorMessage = null;

    try {
      final request = SwapRequest(
        receiverId: otherUserId,
        proposedBookId: _selectedMyBook!.id!,
        requestedBookId: _selectedOtherBook!.id!,
        message: messageController.text.trim().isNotEmpty
            ? messageController.text.trim()
            : null,
      );

      final response = await service.createSwapProposal(request);

      if (response.isSuccessful && response.data != null) {
        _createdSwap = response.data;
        _swapSuccess = true;
        isLoading = false;
        reloadState();
        return true;
      } else {
        _errorMessage = response.message ?? 'Takas önerisi gönderilemedi';
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Takas önerisi gönderilirken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }

  /// Hata mesajını temizle
  void clearError() {
    _errorMessage = null;
    reloadState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
