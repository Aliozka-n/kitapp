import '../models/service_response.dart';
import '../../domain/dtos/book_dto.dart';

/// Home Service Interface - Test edilebilirlik ve loose coupling için
abstract class IHomeService {
  /// Book listesi getir
  Future<ServiceResponse<List<BookResponse>>> getBooks({
    String? status,
    String? category,
    String? filter,
  });

  /// Book ara
  Future<ServiceResponse<List<BookResponse>>> searchBooks(String query);
}

