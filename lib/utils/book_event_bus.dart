import 'dart:async';

/// Book Event Types
enum BookEventType {
  deleted,
  favoriteAdded,
  favoriteRemoved,
  added,
  updated,
}

/// Book Event Data
class BookEvent {
  final String bookId;
  final BookEventType type;

  BookEvent({required this.bookId, required this.type});
}

/// Global Book Event Bus - Kitap değişikliklerini tüm uygulamaya yayar
class BookEventBus {
  // Singleton pattern
  static final BookEventBus _instance = BookEventBus._internal();
  factory BookEventBus() => _instance;
  BookEventBus._internal();

  final _controller = StreamController<BookEvent>.broadcast();

  /// Event stream
  Stream<BookEvent> get events => _controller.stream;

  /// Fire event
  void fire(BookEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Dispose
  void dispose() {
    _controller.close();
  }
}
