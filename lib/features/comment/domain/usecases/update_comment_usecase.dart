import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class UpdateCommentUseCase implements UseCase<CommentEntity, CommentEntity> {
  final CommentRepository repository;

  UpdateCommentUseCase(this.repository);

  @override
  Future<Either<Failure, CommentEntity>> call(CommentEntity commentEntity) async {
    return await repository.updateComment(commentEntity);
  }
}
