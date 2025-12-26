import '../../base/models/base_model.dart';

/// Message Model - Domain model
class MessageModel extends BaseModel {
  final String? userName;
  final String? lastMessage;
  final String? date;

  MessageModel({
    this.userName,
    this.lastMessage,
    this.date,
  }) : super();

  MessageModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        lastMessage = json['lastMessage'],
        date = json['date'];

  @override
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'lastMessage': lastMessage,
      'date': date,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageModel &&
        other.userName == userName &&
        other.lastMessage == lastMessage &&
        other.date == date;
  }

  @override
  int get hashCode {
    return userName.hashCode ^ lastMessage.hashCode ^ date.hashCode;
  }
}

