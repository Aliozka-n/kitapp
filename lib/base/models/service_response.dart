/// Generic Service Response Model
class ServiceResponse<T> {
  final bool isSuccessful;
  final T? data;
  final String? message;
  final int? statusCode;

  ServiceResponse({
    required this.isSuccessful,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ServiceResponse.success({
    T? data,
    String? message,
    int? statusCode,
  }) {
    return ServiceResponse<T>(
      isSuccessful: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ServiceResponse.error({
    String? message,
    int? statusCode,
  }) {
    return ServiceResponse<T>(
      isSuccessful: false,
      message: message,
      statusCode: statusCode,
    );
  }
}

