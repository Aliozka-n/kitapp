import '../../base/models/base_model.dart';

/// Book Model - Domain model
class BookModel extends BaseModel {
  final String? id;
  final String? name;
  final String? writer;
  final String? type;
  final String? language; // Typo düzeltildi: lenguage -> language

  BookModel({
    this.id,
    this.name,
    this.writer,
    this.type,
    this.language,
  }) : super();

  BookModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name'],
        writer = json['writer'],
        type = json['type'],
        language = json['language'] ?? json['lenguage']; // Backward compatibility

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'writer': writer,
      'type': type,
      'language': language,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookModel &&
        other.id == id &&
        other.name == name &&
        other.writer == writer &&
        other.type == type &&
        other.language == language;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        writer.hashCode ^
        type.hashCode ^
        language.hashCode;
  }
}

