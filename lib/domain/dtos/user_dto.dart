/// User Request DTO - API'ye göndermek için
class UserRequest {
  final String? name;
  final String? email;
  final String? il;
  final String? ilce;
  final String? avatarUrl;
  final double? latitude;
  final double? longitude;

  UserRequest({
    this.name,
    this.email,
    this.il,
    this.ilce,
    this.avatarUrl,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'il': il,
      'ilce': ilce,
      'avatar_url': avatarUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

/// User Response DTO - API'den gelen veriyi parse etmek için
class UserResponse {
  final String? id;
  final String? name;
  final String? email;
  final String? il;
  final String? ilce;
  final double? rating;
  final String? avatarUrl;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserResponse({
    this.id,
    this.name,
    this.email,
    this.il,
    this.ilce,
    this.rating,
    this.avatarUrl,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
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

    return UserResponse(
      id: json['id']?.toString(),
      name: json['name'],
      email: json['email'],
      il: json['il'],
      ilce: json['ilce'],
      rating: json['rating'] != null ? (json['rating'] is num ? json['rating'].toDouble() : double.tryParse(json['rating'].toString())) : null,
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
      latitude: json['latitude'] != null ? (json['latitude'] is num ? json['latitude'].toDouble() : double.tryParse(json['latitude'].toString())) : null,
      longitude: json['longitude'] != null ? (json['longitude'] is num ? json['longitude'].toDouble() : double.tryParse(json['longitude'].toString())) : null,
      createdAt: parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: parseDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'il': il,
      'ilce': ilce,
      'rating': rating,
      'avatarUrl': avatarUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

