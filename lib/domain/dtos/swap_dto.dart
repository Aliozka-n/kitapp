import '../enums/swap_status.dart';
import 'book_dto.dart';

/// Swap Request DTO - Takas önerisi oluşturmak için
class SwapRequest {
  final String receiverId;
  final String proposedBookId;
  final String requestedBookId;
  final String? message;

  SwapRequest({
    required this.receiverId,
    required this.proposedBookId,
    required this.requestedBookId,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'owner_id': receiverId,
      'offered_book_id': proposedBookId,
      'requested_book_id': requestedBookId,
      'message': message,
    };
  }
}

/// Swap Response DTO - Takas önerisi yanıtı
class SwapResponse {
  final String? id;
  final String? requesterId;
  final String? ownerId;
  final String? requestedBookId;
  final String? offeredBookId;
  final SwapStatus status;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // İlişkili veriler (join ile gelir)
  final BookResponse? requestedBook;
  final BookResponse? offeredBook;
  final String? requesterName;
  final String? ownerName;

  SwapResponse({
    this.id,
    this.requesterId,
    this.ownerId,
    this.requestedBookId,
    this.offeredBookId,
    this.status = SwapStatus.pending,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.requestedBook,
    this.offeredBook,
    this.requesterName,
    this.ownerName,
  });

  factory SwapResponse.fromJson(Map<String, dynamic> json) {
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

    // İlişkili kitap verilerini parse et
    BookResponse? parseBook(dynamic bookData) {
      if (bookData == null) return null;
      if (bookData is Map<String, dynamic>) {
        return BookResponse.fromJson(bookData);
      }
      return null;
    }

    return SwapResponse(
      id: json['id']?.toString(),
      requesterId: json['requester_id']?.toString(),
      ownerId: json['owner_id']?.toString(),
      requestedBookId: json['requested_book_id']?.toString(),
      offeredBookId: json['offered_book_id']?.toString(),
      status: SwapStatus.fromString(json['status']),
      message: json['message'],
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      requestedBook: parseBook(json['requested_book']),
      offeredBook: parseBook(json['offered_book']),
      requesterName: json['requester_name'] ?? json['requester']?['name'],
      ownerName: json['owner_name'] ?? json['owner']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requesterId': requesterId,
      'ownerId': ownerId,
      'requestedBookId': requestedBookId,
      'offeredBookId': offeredBookId,
      'status': status.displayName,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Kullanıcı bu takas teklifinin sahibi mi?
  bool isOwner(String? userId) => ownerId == userId;

  /// Kullanıcı bu takas teklifini gönderen mi?
  bool isRequester(String? userId) => requesterId == userId;

  /// Takas kabul edilebilir mi?
  bool get canAccept => status == SwapStatus.pending;

  /// Takas reddedilebilir mi?
  bool get canReject => status == SwapStatus.pending;

  /// Takas iptal edilebilir mi?
  bool canCancel(String? userId) =>
      status == SwapStatus.pending && isRequester(userId);

  /// Yeni status ile kopyala
  SwapResponse copyWithStatus(SwapStatus newStatus) {
    return SwapResponse(
      id: id,
      requesterId: requesterId,
      ownerId: ownerId,
      requestedBookId: requestedBookId,
      offeredBookId: offeredBookId,
      status: newStatus,
      message: message,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      requestedBook: requestedBook,
      offeredBook: offeredBook,
      requesterName: requesterName,
      ownerName: ownerName,
    );
  }
}

/// Swap List Response DTO
class SwapListResponse {
  final List<SwapResponse> swaps;
  final int totalCount;

  SwapListResponse({
    required this.swaps,
    required this.totalCount,
  });

  factory SwapListResponse.fromJson(Map<String, dynamic> json) {
    return SwapListResponse(
      swaps: (json['swaps'] as List<dynamic>?)
              ?.map(
                  (item) => SwapResponse.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}
