import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class CreatePostUseCase implements UseCase<PostEntity, PostEntity> {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(PostEntity params) async {
    return await repository.createPost(params);
  }
}
