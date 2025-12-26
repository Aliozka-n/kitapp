import '../models/service_response.dart';
import '../../domain/dtos/book_dto.dart';

/// Book Detail Service Interface
abstract class IBookDetailService {
  /// Kitap detayı getir
  Future<ServiceResponse<BookResponse>> getBookDetail(String bookId);

  /// Kitap sil
  Future<ServiceResponse<bool>> deleteBook(String bookId);

  /// Kitap güncelle
  Future<ServiceResponse<BookResponse>> updateBook(
    String bookId,
    BookRequest request,
  );
}

