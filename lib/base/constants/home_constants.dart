/// Home Screen Constants - Magic strings ve numbers'ları burada topla
class HomeConstants {
  // Private constructor - Static sınıf
  HomeConstants._();

  // Filter seçenekleri
  static const List<String> filters = [
    'Tümü',
    'Kitaplarım',
    'Favorilerim',
    'Popüler',
    'Yakınımda',
    'Bilim Kurgu',
    'Klasik',
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

