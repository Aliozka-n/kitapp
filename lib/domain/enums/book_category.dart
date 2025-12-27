enum BookCategory {
  fiction('Kurgu'),
  nonFiction('Kurgu Dışı'),
  sciFi('Bilim Kurgu'),
  mystery('Gizem'),
  romance('Romantik'),
  thriller('Gerilim'),
  horror('Korku'),
  fantasy('Fantastik'),
  biography('Biyografi'),
  history('Tarih'),
  classic('Klasik'),
  other('Diğer');

  final String displayName;
  const BookCategory(this.displayName);

  static List<String> get names => values.map((v) => v.displayName).toList();

  static BookCategory fromName(String name) {
    return values.firstWhere(
      (v) => v.displayName.toLowerCase() == name.toLowerCase(),
      orElse: () => BookCategory.other,
    );
  }
}
