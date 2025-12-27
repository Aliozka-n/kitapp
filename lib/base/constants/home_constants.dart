import '../../domain/enums/book_category.dart';

/// Home Screen Constants - Magic strings ve numbers'ları burada topla
class HomeConstants {
  // Private constructor - Static sınıf
  HomeConstants._();

  // Sabit filtreler
  static const String all = 'Tümü';
  static const String myBooks = 'Kitaplarım';
  static const String myFavorites = 'Favorilerim';
  static const String popular = 'Popüler';
  static const String nearMe = 'Yakınımda';

  // Filter seçenekleri
  static List<String> get filters => [
        all,
        myBooks,
        myFavorites,
        popular,
        nearMe,
        ...BookCategory.names,
      ];

  // Default filter
  static const String defaultFilter = 'Tümü';

  // Search placeholder
  static const String searchPlaceholder = 'Başlık, yazar, ISBN ara...';

  // Section başlıkları
  static const String newlyListedTitle = 'Yeni Eklenenler';
  static const String recommendedTitle = 'Sizin İçin Önerilenler';
  static const String seeAllText = 'Tümünü Gör';

  // Status mesajları
  static const String availableStatus = 'Müsait';
  static const String loadingBooksMessage = 'Kitaplar yükleniyor...';
  static const String noBooksTitle = 'Henüz kitap bulunmuyor';
  static const String noBooksMessage =
      'Kütüphaneye yeni kitaplar eklendiğinde burada görünecek';

  // List limits
  static const int newlyListedLimit = 3;
  static const int recommendedLimit = 4;
}
