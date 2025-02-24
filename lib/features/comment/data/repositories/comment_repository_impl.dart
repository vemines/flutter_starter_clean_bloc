import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../../domain/usecases/add_comment_usecase.dart';
import '../../domain/usecases/get_comments_by_post_id_usecase.dart';
import '../datasources/comment_remote_data_source.dart';
import '../models/comment_model.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CommentRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId(GetCommentsParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final comments = await remoteDataSource.getCommentsByPostId(params.postId);
        return Right(comments);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> addComment(AddCommentParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final comment = await remoteDataSource.addComment(params);
        return Right(comment);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> updateComment(CommentEntity params) async {
    if (await networkInfo.isConnected) {
      try {
        final comment = await remoteDataSource.updateComment(CommentModel.fromEntity(params));
        return Right(comment);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(CommentEntity params) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteComment(CommentModel.fromEntity(params));
        return const Right(null);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
