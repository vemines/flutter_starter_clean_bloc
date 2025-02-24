import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

class StringUtils {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputStringFailure(message: 'Input String must be number and gte 0'));
    }
  }
}

class InvalidInputStringFailure extends Failure {
  const InvalidInputStringFailure({required super.message});
}
