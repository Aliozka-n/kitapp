/// Swap Status Enum - Takas durumları
enum SwapStatus {
  pending('Beklemede', 'PENDING'),
  accepted('Kabul Edildi', 'ACCEPTED'),
  rejected('Reddedildi', 'REJECTED'),
  cancelled('İptal Edildi', 'CANCELLED'),
  completed('Tamamlandı', 'COMPLETED');

  final String displayName;
  final String code;

  const SwapStatus(this.displayName, this.code);

  /// String'den SwapStatus'a dönüştür
  static SwapStatus fromString(String? status) {
    if (status == null) return SwapStatus.pending;

    final normalizedStatus = status.toLowerCase().trim();

    switch (normalizedStatus) {
      case 'beklemede':
      case 'pending':
        return SwapStatus.pending;
      case 'kabul edildi':
      case 'accepted':
        return SwapStatus.accepted;
      case 'reddedildi':
      case 'rejected':
        return SwapStatus.rejected;
      case 'iptal edildi':
      case 'cancelled':
        return SwapStatus.cancelled;
      case 'tamamlandı':
      case 'completed':
        return SwapStatus.completed;
      default:
        return SwapStatus.pending;
    }
  }

  /// Duruma göre ikon döndür
  String get icon {
    switch (this) {
      case SwapStatus.pending:
        return '⏳';
      case SwapStatus.accepted:
        return '✅';
      case SwapStatus.rejected:
        return '❌';
      case SwapStatus.cancelled:
        return '🚫';
      case SwapStatus.completed:
        return '🎉';
    }
  }

  /// Aktif bir takas mı?
  bool get isActive =>
      this == SwapStatus.pending || this == SwapStatus.accepted;

  /// Tamamlanmış mı?
  bool get isFinalized =>
      this == SwapStatus.completed ||
      this == SwapStatus.rejected ||
      this == SwapStatus.cancelled;
}
