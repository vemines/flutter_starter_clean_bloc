import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetCommentsByPostIdUseCase implements UseCase<List<CommentEntity>, GetCommentsParams> {
  final CommentRepository repository;

  GetCommentsByPostIdUseCase(this.repository);

  @override
  Future<Either<Failure, List<CommentEntity>>> call(GetCommentsParams params) async {
    return await repository.getCommentsByPostId(params);
  }
}

class GetCommentsParams extends PaginationParams {
  final int postId;

  const GetCommentsParams({
    required this.postId,
    required super.page,
    required super.limit,
    super.order,
  });
}
