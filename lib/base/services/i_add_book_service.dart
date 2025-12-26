import '../models/service_response.dart';
import '../../domain/dtos/book_dto.dart';

/// Add Book Service Interface
abstract class IAddBookService {
  /// Yeni kitap ekle
  Future<ServiceResponse<BookResponse>> addBook(BookRequest request);
}
