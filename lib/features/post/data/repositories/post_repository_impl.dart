import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PostEntity>>> getAllPosts(PaginationParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts(params);
        await localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on CacheException {
        return Left(NoCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(IdParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await remoteDataSource.getPostById(params.id);
        return Right(remotePost);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, PostEntity>> createPost(PostEntity post) async {
    if (await networkInfo.isConnected) {
      try {
        final postModel = PostModel.fromEntity(post);
        final remotePost = await remoteDataSource.createPost(postModel);
        return Right(remotePost);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, PostEntity>> updatePost(PostEntity post) async {
    if (await networkInfo.isConnected) {
      try {
        final postModel = PostModel.fromEntity(post);
        final remotePost = await remoteDataSource.updatePost(postModel);
        return Right(remotePost);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(PostEntity post) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deletePost(post.id);
        return const Right(null);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> searchPosts(PaginationWithSearchParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.searchPosts(params);
        return Right(remotePosts);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getBookmarkedPosts(ListIdParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPostsByIds(params);
        return Right(remotePosts);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
