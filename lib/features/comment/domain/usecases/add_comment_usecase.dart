import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class AddCommentUseCase implements UseCase<CommentEntity, AddCommentParams> {
  final CommentRepository repository;

  AddCommentUseCase(this.repository);

  @override
  Future<Either<Failure, CommentEntity>> call(AddCommentParams params) async {
    return await repository.addComment(params);
  }
}

class AddCommentParams extends Equatable {
  final int postId;
  final int userId;
  final String body;

  const AddCommentParams({required this.postId, required this.userId, required this.body});

  @override
  List<Object?> get props => [postId, userId, body];
}
