import '../../base/models/base_model.dart';

/// User Model - Domain model
class UserModel extends BaseModel {
  String? id;
  final String? name;
  final String? email;
  final String? il;
  final String? ilce;

  UserModel({
    this.id,
    this.name,
    this.il,
    this.ilce,
    this.email,
  }) : super();

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name'],
        email = json['email'],
        il = json['il'],
        ilce = json['ilce'];

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'il': il,
      'ilce': ilce,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.il == il &&
        other.ilce == ilce;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        il.hashCode ^
        ilce.hashCode;
  }
}

