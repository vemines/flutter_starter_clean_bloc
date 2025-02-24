import 'package:equatable/equatable.dart';

import '../constants/constants.dart';

abstract class Failure extends Equatable {
  final String? message;
  final StackTrace? stackTrace;
  final String? code;
  final String? at;
  const Failure({this.message, this.code, this.stackTrace, this.at});

  @override
  List<Object?> get props => [message, code, stackTrace];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = kServerFailureMessage, super.code = '-1', super.stackTrace});

  @override
  List<Object?> get props => [message, code, stackTrace];
}

class AppFailure extends Failure {
  const AppFailure({super.message = kServerFailureMessage});

  @override
  List<Object?> get props => [message];
}

class NoCacheFailure extends Failure {
  const NoCacheFailure({super.message = kNoCacheFailureMessage, super.code, super.stackTrace});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = kTimeoutFailure, super.code, super.stackTrace});
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({
    super.message = kNoInternetFailureMessage,
    super.code,
    super.stackTrace,
  });
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({
    super.message = kInvalidInputFailureMessage,
    super.code,
    super.stackTrace,
  });
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({
    super.message = kUnauthenticatedFailure,
    super.stackTrace,
    super.code,
  });
}
