import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class VerifySecretUseCase implements UseCase<bool, AuthEntity> {
  final AuthRepository repository;

  VerifySecretUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(AuthEntity auth) async {
    return await repository.verifySecret(auth);
  }
}
