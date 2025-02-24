import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetAllUsersUseCase implements UseCase<List<UserEntity>, PaginationParams> {
  final UserRepository repository;

  GetAllUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(PaginationParams params) async {
    return await repository.getAllUsers(params);
  }
}
