import '../../base/models/service_response.dart';
import '../../base/services/error_handler.dart';
import '../../base/services/i_home_service.dart';
import '../../domain/dtos/book_dto.dart';
import '../home/home_service.dart';

/// Search Service - Arama işlemleri için servis
class SearchService {
  final IHomeService _homeService;

  SearchService({IHomeService? homeService})
      : _homeService = homeService ?? HomeService();

  /// Gelişmiş arama yap
  Future<ServiceResponse<List<BookResponse>>> advancedSearch({
    String? query,
    String? type,
    String? language,
    String? writer,
  }) async {
    try {
      // Eğer sadece query varsa basit arama yap
      if (query != null && query.isNotEmpty) {
        return await _homeService.searchBooks(query);
      }

      // Gelişmiş filtreleme için tüm kitapları getir ve filtrele
      final response = await _homeService.getBooks(
        category: type,
      );

      if (!response.isSuccessful || response.data == null) {
        return response;
      }

      List<BookResponse> filteredBooks = response.data!;

      // Language filtresi
      if (language != null && language.isNotEmpty) {
        filteredBooks = filteredBooks
            .where((book) =>
                book.language?.toLowerCase() == language.toLowerCase())
            .toList();
      }

      // Writer filtresi
      if (writer != null && writer.isNotEmpty) {
        filteredBooks = filteredBooks
            .where((book) =>
                book.writer?.toLowerCase().contains(writer.toLowerCase()) ??
                false)
            .toList();
      }

      return ServiceResponse.success(
        data: filteredBooks,
        message: 'Arama tamamlandı',
        statusCode: 200,
      );
    } catch (e) {
      return ErrorHandler.createErrorResponse<List<BookResponse>>(
        error: e,
        statusCode: 500,
      );
    }
  }

  /// Basit arama yap
  Future<ServiceResponse<List<BookResponse>>> search(String query) async {
    return await _homeService.searchBooks(query);
  }
}

