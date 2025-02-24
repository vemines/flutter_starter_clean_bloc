import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class DeletePostUseCase implements UseCase<void, PostEntity> {
  final PostRepository repository;
  DeletePostUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(PostEntity postEntity) async {
    return await repository.deletePost(postEntity);
  }
}
