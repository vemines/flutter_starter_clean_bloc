import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/comment_entity.dart';
import '../usecases/add_comment_usecase.dart';
import '../usecases/get_comments_by_post_id_usecase.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId(GetCommentsParams params);
  Future<Either<Failure, CommentEntity>> addComment(AddCommentParams params);
  Future<Either<Failure, CommentEntity>> updateComment(CommentEntity params);
  Future<Either<Failure, void>> deleteComment(CommentEntity params);
}
