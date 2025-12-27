import 'dart:async';
import 'package:flutter/material.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../domain/dtos/book_dto.dart';
import '../../../utils/book_event_bus.dart';
import '../search_service.dart';

/// Search ViewModel - Arama ekranının durum ve iş kuralları
class SearchViewModel extends BaseViewModel {
  final SearchService service;

  // PRIVATE FIELDS
  List<BookResponse> _searchResults = [];
  final TextEditingController searchController = TextEditingController();
  String? _errorMessage;
  String? _selectedType;
  String? _selectedLanguage;
  Timer? _debounceTimer;
  StreamSubscription<BookEvent>? _bookEventSubscription;

  // PUBLIC GETTERS
  List<BookResponse> get searchResults => _searchResults;
  String? get errorMessage => _errorMessage;
  String? get selectedType => _selectedType;
  String? get selectedLanguage => _selectedLanguage;
  bool get hasSearchQuery => searchController.text.isNotEmpty;

  // Constructor
  SearchViewModel({required this.service}) {
    searchController.addListener(_onSearchChanged);
    _listenToBookEvents();
  }

  /// Kitap değişikliklerini dinle
  void _listenToBookEvents() {
    _bookEventSubscription = BookEventBus().events.listen((event) {
      if (event.type == BookEventType.deleted) {
        _searchResults.removeWhere((b) => b.id == event.bookId);
        reloadState();
      } else {
        // Arama sorgusu varsa aramayı yenile
        final query = searchController.text.trim();
        if (query.isNotEmpty ||
            _selectedType != null ||
            _selectedLanguage != null) {
          _executeSearch(query, isSilent: true);
        }
      }
    });
  }

  @override
  FutureOr<void> init() async {
    // İlk yüklemede tüm kitapları göster (opsiyonel)
    // await loadAllBooks();
  }

  /// Arama yap
  Future<void> performSearch() async {
    final query = searchController.text.trim();

    // Debounce - kullanıcı yazmayı bitirdikten 500ms sonra arama yap
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _executeSearch(query);
    });
  }

  /// Arama yap (Alias for performSearch for view consistency)
  Future<void> search(String query) async {
    await performSearch();
  }

  /// Arama işlemini gerçekleştir
  Future<void> _executeSearch(String query, {bool isSilent = false}) async {
    if (!isSilent) isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.advancedSearch(
        query: query.isNotEmpty ? query : null,
        type: _selectedType,
        language: _selectedLanguage,
      );

      if (response.isSuccessful && response.data != null) {
        _searchResults = response.data!;
        _errorMessage = null;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Arama başarısız';
        _searchResults = [];
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Arama yapılırken hata oluştu';
      _searchResults = [];
      reloadState();
    } finally {
      if (!isSilent) isLoading = false;
    }
  }

  /// Search değiştiğinde
  void _onSearchChanged() {
    final query = searchController.text.trim();
    if (query.isEmpty) {
      _searchResults = [];
      _errorMessage = null;
      reloadState();
    } else {
      performSearch();
    }
  }

  /// Type filtresi değiştir
  void setTypeFilter(String? type) {
    _selectedType = type;
    if (hasSearchQuery || _selectedLanguage != null) {
      _executeSearch(searchController.text.trim());
    }
  }

  /// Language filtresi değiştir
  void setLanguageFilter(String? language) {
    _selectedLanguage = language;
    if (hasSearchQuery || _selectedType != null) {
      _executeSearch(searchController.text.trim());
    }
  }

  /// Filtreleri temizle
  void clearFilters() {
    _selectedType = null;
    _selectedLanguage = null;
    if (hasSearchQuery) {
      _executeSearch(searchController.text.trim());
    } else {
      _searchResults = [];
      reloadState();
    }
  }

  /// Arama sorgusunu temizle
  void clearSearch() {
    searchController.clear();
    _searchResults = [];
    _errorMessage = null;
    _selectedType = null;
    _selectedLanguage = null;
    reloadState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _bookEventSubscription?.cancel();
    super.dispose();
  }
}
