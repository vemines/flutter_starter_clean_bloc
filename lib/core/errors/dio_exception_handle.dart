part of 'exceptions.dart';

Never handleDioException(DioException e, String? at) {
  if (e.response != null) {
    final statusCode = e.response!.statusCode;
    final statusMessage = e.response!.statusMessage;

    switch (statusCode) {
      case 400:
        throw ServerException(message: statusMessage ?? 'Bad Request', statusCode: statusCode);
      case 401:
        throw InvalidCredentialsException();
      case 403:
        throw UnauthenticatedException();
      case 404:
        throw ServerException(message: statusMessage ?? 'Not Found', statusCode: statusCode);
      case 409:
        throw ServerException(message: statusMessage ?? 'Conflict', statusCode: statusCode);
      case 500:
        throw ServerException(
          message: statusMessage ?? 'Internal Server Error',
          statusCode: statusCode,
        );
      default:
        throw ServerException(message: statusMessage ?? 'Server error', statusCode: statusCode);
    }
  } else {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw TimeoutException();
    }
  }
  throw ServerException(message: e.message ?? "Error at: $at");
}
