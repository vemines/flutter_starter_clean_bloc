part of 'exceptions.dart';

Failure handleRepositoryException(Object e) {
  if (e is ServerException) {
    return e.toFailure();
  } else if (e is TimeoutException) {
    return TimeoutFailure();
  } else {
    return ServerFailure(message: e.toString());
  }
}
