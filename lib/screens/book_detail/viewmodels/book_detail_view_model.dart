import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../base/models/service_response.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/book_dto.dart';
import '../book_detail_service.dart';

/// Book Detail ViewModel - Book Detail ekranının durum ve iş kuralları
class BookDetailViewModel extends BaseViewModel {
  final BookDetailService service;
  final String bookId;

  // PRIVATE FIELDS
  BookResponse? _book;
  String? _errorMessage;
  bool _isFavorite = false;

  // PUBLIC GETTERS
  BookResponse? get book => _book;
  String? get errorMessage => _errorMessage;
  bool get isFavorite => _isFavorite;
  
  // Owner bilgileri
  String? get ownerId => _book?.userId;
  String? get ownerName => _book?.userName ?? 'Kullanıcı';
  
  // Kullanıcı kendi kitabına mı bakıyor?
  bool get isMyBook {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    return currentUserId != null && ownerId == currentUserId;
  }

  // Constructor
  BookDetailViewModel({
    required this.service,
    required this.bookId,
  });

  @override
  FutureOr<void> init() async {
    await loadBookDetail();
    await checkFavoriteStatus();
  }

  /// Book detail yükle
  Future<void> loadBookDetail() async {
    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.getBookDetail(bookId);

      if (response.isSuccessful && response.data != null) {
        _book = response.data!;
        _errorMessage = null;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Kitap detayı yüklenemedi';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Kitap detayı yüklenirken hata oluştu';
      reloadState();
    } finally {
      isLoading = false;
    }
  }

  /// Favori durumunu kontrol et
  Future<void> checkFavoriteStatus() async {
    try {
      final response = await service.isFavorite(bookId);
      if (response.isSuccessful) {
        _isFavorite = response.data ?? false;
        reloadState();
      }
    } catch (e) {
      // Sessizce geç
    }
  }

  /// Favori ekle/çıkar
  Future<bool> toggleFavorite() async {
    try {
      ServiceResponse<bool> response;
      
      if (_isFavorite) {
        response = await service.removeFavorite(bookId);
      } else {
        response = await service.addFavorite(bookId);
      }

      if (response.isSuccessful) {
        _isFavorite = !_isFavorite;
        reloadState();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Kitap sil
  Future<bool> deleteBook() async {
    isLoading = true;
    _errorMessage = null;
    reloadState();

    try {
      final response = await service.deleteBook(bookId);

      if (response.isSuccessful) {
        isLoading = false;
        return true;
      } else {
        _errorMessage = response.message ?? 'Kitap silinemedi';
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Kitap silinirken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }
}

