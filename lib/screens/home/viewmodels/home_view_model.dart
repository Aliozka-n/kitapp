import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../base/viewmodels/base_view_model.dart';
import '../../../base/constants/home_constants.dart';
import '../../../base/services/favorites_service.dart';
import '../../../domain/dtos/book_dto.dart';
import '../../../domain/models/book_model.dart';
import '../../../utils/book_event_bus.dart';
import '../home_service.dart';

/// Home ViewModel - Home ekranının durum ve iş kuralları
class HomeViewModel extends BaseViewModel {
  final HomeService service;

  // PRIVATE FIELDS
  List<BookResponse> _books = [];
  List<BookResponse> _filteredBooks = [];
  final TextEditingController searchController = TextEditingController();
  String? _errorMessage;
  String _selectedFilter = HomeConstants.defaultFilter;
  final FavoritesService _favoritesService = FavoritesService();
  StreamSubscription<BookEvent>? _bookEventSubscription;

  // ValueNotifier for granular updates
  final ValueNotifier<List<BookResponse>> filteredBooksNotifier =
      ValueNotifier<List<BookResponse>>([]);

  // PUBLIC GETTERS
  List<BookResponse> get books => _filteredBooks;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;

  /// Arama aktif mi? (Arama barına yazı yazıldığında true)
  bool get isSearchActive => searchController.text.trim().isNotEmpty;

  // Get newly listed books (last N)
  List<BookResponse> get newlyListedBooks {
    final sorted = List<BookResponse>.from(_books);
    sorted.sort((a, b) {
      // Sort by creation date - newest first
      final aDate = a.createdAt ?? DateTime(1970);
      final bDate = b.createdAt ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });
    return sorted.take(HomeConstants.newlyListedLimit).toList();
  }

  // Get recommended books (first N for grid)
  List<BookResponse> get recommendedBooks {
    return _books.take(HomeConstants.recommendedLimit).toList();
  }

  // Constructor
  HomeViewModel({required this.service}) {
    searchController.addListener(_onSearchChanged);
    _listenToBookEvents();
  }

  /// Kitap değişikliklerini dinle
  void _listenToBookEvents() {
    _bookEventSubscription = BookEventBus().events.listen((event) async {
      if (event.type == BookEventType.deleted) {
        // Kitap silindiğinde listeden çıkar (Immediate UI feedback)
        _books = _books.where((b) => b.id != event.bookId).toList();
        _filteredBooks =
            _filteredBooks.where((b) => b.id != event.bookId).toList();
        filteredBooksNotifier.value = List.from(_filteredBooks);

        // Force UI update
        notifyListeners();

        // Arka planda listeyi yenile (Source of truth sync)
        await loadBooks(isSilent: true);
      } else if (event.type == BookEventType.added ||
          event.type == BookEventType.updated ||
          event.type == BookEventType.favoriteRemoved ||
          event.type == BookEventType.favoriteAdded) {
        // Diğer değişikliklerde listeyi sessizce yenile
        await loadBooks(isSilent: true);
      }
    });
  }

  @override
  FutureOr<void> init() async {
    await loadBooks();
  }

  /// Books yükle
  Future<void> loadBooks({bool isSilent = false}) async {
    if (!isSilent) isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.getBooks();

      if (response.isSuccessful && response.data != null) {
        _books = response.data ?? [];
        await _onSearchChanged(); // Arama ve filtreyi birlikte uygula
        _errorMessage = null;
      } else {
        _errorMessage = response.message ?? 'Kitaplar yüklenemedi';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Kitaplar yüklenirken hata oluştu';
      reloadState();
    } finally {
      if (!isSilent) isLoading = false;
    }
  }

  /// Book ara
  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      _filteredBooks = List<BookResponse>.from(_books);
      reloadState();
      return;
    }

    isLoading = true;
    _errorMessage = null;

    try {
      final response = await service.searchBooks(query);

      if (response.isSuccessful && response.data != null) {
        _filteredBooks = response.data ?? [];
        _errorMessage = null;
        filteredBooksNotifier.value = _filteredBooks;
        reloadState();
      } else {
        _errorMessage = response.message ?? 'Arama başarısız';
        reloadState();
      }
    } catch (e) {
      _errorMessage = 'Arama yapılırken hata oluştu';
      reloadState();
    } finally {
      isLoading = false;
    }
  }

  /// Filter değiştir
  Future<void> setFilter(String filter) async {
    _selectedFilter = filter;
    await _onSearchChanged(); // Arama ve filtreyi birlikte uygula
  }

  /// Filter uygula
  Future<void> _applyFilter() async {
    try {
      if (_selectedFilter == HomeConstants.all) {
        // Tümü - Tüm kitaplar (YENİ LİSTE OLUŞTUR - referans değil!)
        _filteredBooks = List<BookResponse>.from(_books);
      } else if (_selectedFilter == HomeConstants.myBooks) {
        // Kitaplarım - Sadece kullanıcının kitapları
        final currentUserId = await _getCurrentUserId();
        if (currentUserId != null) {
          _filteredBooks = _books.where((book) {
            return book.userId == currentUserId;
          }).toList();
        } else {
          _filteredBooks = [];
        }
      } else if (_selectedFilter == HomeConstants.myFavorites) {
        // Favorilerim - Favori kitaplar
        try {
          final response = await _favoritesService.getFavorites();
          if (response.isSuccessful && response.data != null) {
            final favoriteBookIds = response.data!.map((b) => b.id).toSet();
            _filteredBooks = _books.where((book) {
              return favoriteBookIds.contains(book.id);
            }).toList();
          } else {
            _filteredBooks = [];
          }
        } catch (e) {
          _filteredBooks = [];
        }
      } else if (_selectedFilter == HomeConstants.popular) {
        // Popüler - Tüm kitaplar (en yeni önce)
        _filteredBooks = List.from(_books);
        _filteredBooks.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
      } else if (_selectedFilter == HomeConstants.nearMe) {
        // Yakınımda - TODO: Implement location-based filtering
        _filteredBooks = List<BookResponse>.from(_books);
      } else {
        // Filter by type/genre (BookCategory)
        _filteredBooks = _books.where((book) {
          return book.type?.toLowerCase() == _selectedFilter.toLowerCase();
        }).toList();
      }
    } catch (e) {
      // Hata durumunda boş liste döndür
      _filteredBooks = [];
    }
  }

  /// Mevcut kullanıcı ID'sini al
  Future<String?> _getCurrentUserId() async {
    try {
      return Supabase.instance.client.auth.currentUser?.id;
    } catch (e) {
      return null;
    }
  }

  /// Search değiştiğinde
  Future<void> _onSearchChanged() async {
    final query = searchController.text;
    await _applyFilter(); // Her aramada önce filtreyi uygula

    if (query.isNotEmpty) {
      final searchLower = query.toLowerCase();
      _filteredBooks = _filteredBooks.where((book) {
        final name = book.name?.toLowerCase() ?? '';
        final writer = book.writer?.toLowerCase() ?? '';
        final type = book.type?.toLowerCase() ?? '';
        return name.contains(searchLower) ||
            writer.contains(searchLower) ||
            type.contains(searchLower);
      }).toList();
    }

    filteredBooksNotifier.value = _filteredBooks;
    reloadState();
  }

  /// BookResponse'u BookModel'e çevir (mevcut widget'lar için)
  BookModel? toBookModel(BookResponse book) {
    return BookModel(
      id: book.id,
      name: book.name,
      writer: book.writer,
      type: book.type,
      language: book.language,
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    filteredBooksNotifier.dispose();
    _bookEventSubscription?.cancel();
    super.dispose();
  }
}
