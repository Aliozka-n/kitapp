/// Book Request DTO - API'ye göndermek için
class BookRequest {
  final String? name;
  final String? writer;
  final String? type;
  final String? language;
  final String? imageUrl;
  final String? description;
  final String? status; // Müsait, Takas Edildi, Rezerve, Satıldı

  BookRequest({
    this.name,
    this.writer,
    this.type,
    this.language,
    this.imageUrl,
    this.description,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'writer': writer,
      'type': type,
      'language': language,
      'image_url': imageUrl,
      'description': description,
      'status': status ?? 'Müsait',
    };
  }
}

/// Book Response DTO - API'den gelen veriyi parse etmek için
class BookResponse {
  final String? id;
  final String? name;
  final String? writer;
  final String? type;
  final String? language;
  final String? imageUrl;
  final String? description;
  final String? status; // Müsait, Takas Edildi, Rezerve, Satıldı
  final String? userId;
  final String? userName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookResponse({
    this.id,
    this.name,
    this.writer,
    this.type,
    this.language,
    this.imageUrl,
    this.description,
    this.status,
    this.userId,
    this.userName,
    this.createdAt,
    this.updatedAt,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    // Supabase'den gelen tarih formatını parse et
    DateTime? parseDate(dynamic dateValue) {
      if (dateValue == null) return null;
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    // User bilgisi nested object olarak gelebilir (join ile)
    final userData = json['users'] as Map<String, dynamic>?;
    
    return BookResponse(
      id: json['id']?.toString(),
      name: json['name'],
      writer: json['writer'],
      type: json['type'],
      language: json['language'] ?? json['lenguage'], // Backward compatibility
      imageUrl: json['image_url'] ?? json['imageUrl'],
      description: json['description'],
      status: json['status'] ?? 'Müsait',
      userId: json['user_id']?.toString() ?? userData?['id']?.toString(),
      userName: json['user_name'] ?? userData?['name'] as String?,
      createdAt: parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: parseDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'writer': writer,
      'type': type,
      'language': language,
      'imageUrl': imageUrl,
      'description': description,
      'status': status,
      'userId': userId,
      'userName': userName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

/// Book List Response DTO
class BookListResponse {
  final List<BookResponse> books;
  final int totalCount;

  BookListResponse({
    required this.books,
    required this.totalCount,
  });

  factory BookListResponse.fromJson(Map<String, dynamic> json) {
    return BookListResponse(
      books: (json['books'] as List<dynamic>?)
              ?.map((item) => BookResponse.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'books': books.map((book) => book.toJson()).toList(),
      'totalCount': totalCount,
    };
  }
}

