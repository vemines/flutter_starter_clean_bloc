import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserByIdUseCase implements UseCase<UserEntity, IdParams> {
  final UserRepository repository;

  GetUserByIdUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(IdParams params) async {
    return await repository.getUserById(params);
  }
}
