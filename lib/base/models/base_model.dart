/// Base Model sınıfı - Tüm modeller bu sınıftan türemelidir
abstract class BaseModel {
  /// Constructor
  BaseModel();

  /// JSON'dan model oluştur
  BaseModel.fromJson(Map<String, dynamic> json);

  /// Model'i JSON'a dönüştür
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

