import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase implements UseCase<UserEntity, UserEntity> {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity userEntity) async {
    return await repository.updateUser(userEntity);
  }
}
