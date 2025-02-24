import 'package:dio/dio.dart';

import '../constants/constants.dart';
import 'failures.dart';

part 'dio_exception_handle.dart';
part 'repository_exception_handle.dart';

class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  ServerException({this.message, this.statusCode});
}

extension ServerExceptionToFailure on ServerException {
  ServerFailure toFailure({String? message}) {
    return ServerFailure(
      message: message ?? this.message ?? kServerFailureMessage,
      code: statusCode?.toString() ?? '-1',
    );
  }
}

class TimeoutException implements Exception {
  final String? message;
  TimeoutException({this.message = kTimeoutFailure});
}

class CacheException implements Exception {
  final String? message;
  CacheException({this.message});
}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException({this.message = kInvalidCredentialsExceptionMessage});
}

class UnauthenticatedException implements Exception {
  final String message;
  UnauthenticatedException({this.message = kUnauthenticatedFailure});
}
