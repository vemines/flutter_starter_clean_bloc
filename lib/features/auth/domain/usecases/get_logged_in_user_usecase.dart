import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class GetLoggedInUserUseCase implements UseCase<AuthEntity, NoParams> {
  final AuthRepository repository;

  GetLoggedInUserUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(NoParams params) async {
    return await repository.getLoggedInUser();
  }
}
