/// String Extension - Localization ve utility metodları
extension StringLocalization on String {
  /// Çevirilen metni getir (localization için - şimdilik direkt döndürüyor)
  String get locale => this; // TODO: Localization eklendiğinde .tr() ile değiştirilecek

  /// Büyük harfe çevir (Türkçe karakter desteği ile)
  String get toUpperCaseLocale => this.replaceAll("i", "İ").toUpperCase();
}

/// String Extension - Asset path ve validation
extension StringExtension on String? {
  /// Asset path oluştur
  String toAssets({ImageType type = ImageType.png}) =>
      "assets/images/$this.${type.name}";

  /// Email validation
  bool get isValidEmail {
    if (this == null || this!.isEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this!);
  }

  /// Null-safe string kontrolü
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

/// Image Type Enum
enum ImageType {
  png,
  jpg,
  jpeg,
  svg,
}

