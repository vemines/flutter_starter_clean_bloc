import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostByIdUseCase implements UseCase<PostEntity, IdParams> {
  final PostRepository repository;
  GetPostByIdUseCase(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(IdParams params) async {
    return await repository.getPostById(params);
  }
}
