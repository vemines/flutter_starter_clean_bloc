import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class DeleteCommentUseCase implements UseCase<void, CommentEntity> {
  final CommentRepository repository;

  DeleteCommentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CommentEntity commentEntity) async {
    return await repository.deleteComment(commentEntity);
  }
}
