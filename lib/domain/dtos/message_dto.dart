/// Message Request DTO - API'ye göndermek için
class MessageRequest {
  final String? userName;
  final String? lastMessage;
  final String? date;
  final String? receiverId;
  final String? messageType; // text, image, swap_proposal
  final String? swapProposalId;

  MessageRequest({
    this.userName,
    this.lastMessage,
    this.date,
    this.receiverId,
    this.messageType,
    this.swapProposalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'last_message': lastMessage,
      'date': date,
      'receiver_id': receiverId,
      'message_type': messageType ?? 'text',
      'swap_proposal_id': swapProposalId,
    };
  }
}

/// Message Response DTO - API'den gelen veriyi parse etmek için
class MessageResponse {
  final String? id;
  final String? userName;
  final String? lastMessage;
  final String? date;
  final DateTime? createdAt;
  final String? senderId;
  final String? receiverId;
  final bool? isRead;
  final String? messageType; // text, image, swap_proposal
  final String? swapProposalId;

  MessageResponse({
    this.id,
    this.userName,
    this.lastMessage,
    this.date,
    this.createdAt,
    this.senderId,
    this.receiverId,
    this.isRead,
    this.messageType,
    this.swapProposalId,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
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

    // created_at varsa onu date olarak da kullan
    final createdAtDate = parseDate(json['created_at'] ?? json['createdAt']);
    final dateValue = json['date'] ?? (createdAtDate != null ? createdAtDate.toIso8601String() : null);
    
    return MessageResponse(
      id: json['id']?.toString(),
      userName: json['user_name'] ?? json['userName'],
      lastMessage: json['last_message'] ?? json['lastMessage'],
      date: dateValue?.toString(),
      createdAt: createdAtDate,
      senderId: json['sender_id']?.toString() ?? json['senderId']?.toString(),
      receiverId: json['receiver_id']?.toString() ?? json['receiverId']?.toString(),
      isRead: json['is_read'] ?? json['isRead'] ?? false,
      messageType: json['message_type'] ?? json['messageType'] ?? 'text',
      swapProposalId: json['swap_proposal_id']?.toString() ?? json['swapProposalId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'lastMessage': lastMessage,
      'date': date,
      'createdAt': createdAt?.toIso8601String(),
      'senderId': senderId,
      'receiverId': receiverId,
      'isRead': isRead,
      'messageType': messageType,
      'swapProposalId': swapProposalId,
    };
  }
}

/// Message List Response DTO
class MessageListResponse {
  final List<MessageResponse> messages;
  final int totalCount;

  MessageListResponse({
    required this.messages,
    required this.totalCount,
  });

  factory MessageListResponse.fromJson(Map<String, dynamic> json) {
    return MessageListResponse(
      messages: (json['messages'] as List<dynamic>?)
              ?.map((item) =>
                  MessageResponse.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((message) => message.toJson()).toList(),
      'totalCount': totalCount,
    };
  }
}

