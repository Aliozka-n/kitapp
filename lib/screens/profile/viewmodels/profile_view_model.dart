import 'dart:async';
import 'package:flutter/material.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../base/services/favorites_service.dart';
import '../../../domain/dtos/book_dto.dart';
import '../../../domain/dtos/user_dto.dart';
import '../../../utils/shared_preferences_util.dart';
import '../profile_service.dart';

/// Profile ViewModel - Profile ekranının durum ve iş kuralları
class ProfileViewModel extends BaseViewModel {
  final ProfileService service;

  // PRIVATE FIELDS
  UserResponse? _user;
  String? _errorMessage;
  int _sharedBooksCount = 0;
  List<BookResponse> _myBooks = [];
  List<BookResponse> _favoriteBooks = [];
  int _selectedTabIndex = 0; // 0: My Books, 1: Favorites
  final FavoritesService _favoritesService = FavoritesService();

  // PUBLIC GETTERS
  UserResponse? get user => _user;
  String? get errorMessage => _errorMessage;
  int get sharedBooksCount => _sharedBooksCount;
  List<BookResponse> get myBooks => _myBooks;
  List<BookResponse> get favoriteBooks => _favoriteBooks;
  int get selectedTabIndex => _selectedTabIndex;

  // Constructor
  ProfileViewModel({required this.service});

  @override
  FutureOr<void> init() async {
    await loadProfile();
    await loadSharedBooksCount();
    await loadMyBooks();
    await loadFavoriteBooks();
  }

  /// Profil yükle
  Future<void> loadProfile() async {
    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.getProfile();

      if (response.isSuccessful && response.data != null) {
        _user = response.data!;
        _errorMessage = null;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Profil yüklenemedi';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Profil yüklenirken hata oluştu';
      reloadState();
    } finally {
      isLoading = false;
    }
  }

  /// Paylaşılan kitap sayısını yükle
  Future<void> loadSharedBooksCount() async {
    try {
      final response = await service.getSharedBooksCount();
      if (response.isSuccessful && response.data != null) {
        _sharedBooksCount = response.data!;
        reloadState();
      }
    } catch (e) {
      // Hata durumunda sessizce geç
    }
  }

  /// Kendi kitaplarını yükle
  Future<void> loadMyBooks() async {
    try {
      final response = await service.getCurrentlySharedBooks();
      if (response.isSuccessful && response.data != null) {
        _myBooks = (response.data as List)
            .map((item) => BookResponse.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList();
        reloadState();
      }
    } catch (e) {
      // Hata durumunda sessizce geç
    }
  }

  /// Favori kitapları yükle
  Future<void> loadFavoriteBooks() async {
    try {
      final response = await _favoritesService.getFavorites();
      if (response.isSuccessful && response.data != null) {
        _favoriteBooks = response.data!;
        reloadState();
      }
    } catch (e) {
      // Hata durumunda sessizce geç
    }
  }

  /// Tab değiştir
  void setTabIndex(int index) {
    _selectedTabIndex = index;
    reloadState();
  }

  /// Tüm verileri yeniden yükle (Pull to Refresh için)
  Future<void> refresh() async {
    await Future.wait([
      loadProfile(),
      loadSharedBooksCount(),
      loadMyBooks(),
      loadFavoriteBooks(),
    ]);
  }

  /// Logout işlemi
  Future<bool> logout(BuildContext context) async {
    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.logout();

      if (response.isSuccessful) {
        // SharedPreferences'ı temizle
        final prefs = await SharedPreferencesUtil.getInstance();
        await prefs.removeToken();
        await prefs.remove('userId');
        await prefs.remove('rememberedEmail');
        await prefs.setBool('rememberMe', false);
        
        isLoading = false;
        return true;
      } else {
        _errorMessage = response.message ?? 'Çıkış yapılamadı';
        isLoading = false;
        reloadState();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Çıkış yapılırken hata oluştu';
      isLoading = false;
      reloadState();
      return false;
    }
  }
}

