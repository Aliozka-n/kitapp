import '../models/service_response.dart';

/// Base Service Interface - Tüm servisler bu interface'i implement etmelidir
abstract class BaseService {
  /// Generic service response döndürür
  Future<ServiceResponse<T>> call<T>();
}

