import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getAllPosts(PaginationParams params);
  Future<Either<Failure, PostEntity>> getPostById(IdParams params);
  Future<Either<Failure, PostEntity>> createPost(PostEntity post);
  Future<Either<Failure, PostEntity>> updatePost(PostEntity post);
  Future<Either<Failure, void>> deletePost(PostEntity post);
  Future<Either<Failure, List<PostEntity>>> searchPosts(PaginationWithSearchParams params);
  Future<Either<Failure, List<PostEntity>>> getBookmarkedPosts(ListIdParams params);
}
