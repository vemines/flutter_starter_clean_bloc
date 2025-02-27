import 'package:dio/dio.dart';
import 'package:flutter_starter_clean_bloc/core/constants/enum.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/usecases/add_comment_usecase.dart';
import '../../domain/usecases/get_comments_by_post_id_usecase.dart';
import '../models/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getCommentsByPostId(GetCommentsParams params);
  Future<CommentModel> addComment(AddCommentParams params);
  Future<CommentModel> updateComment(CommentModel comment);
  Future<void> deleteComment(CommentModel comment);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final Dio dio;
  CommentRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CommentModel>> getCommentsByPostId(GetCommentsParams params) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getCommentsByPostId(postId: params.postId),
        queryParameters: {
          '_page': params.page,
          '_limit': params.limit,
          '_sort': 'createdAt',
          '_order': params.order.getString(),
        },
      );
      return (response.data as List).map((e) => CommentModel.fromJson(e)).toList();
    } on DioException catch (e, s) {
      handleDioException(e, s, 'getCommentsByPostId(int postId)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<CommentModel> addComment(AddCommentParams params) async {
    try {
      final response = await dio.post(
        ApiEndpoints.getCommentsByPostId(postId: params.postId),
        data: {'userId': params.userId, 'body': params.body},
      );
      return CommentModel.fromJson(response.data);
    } on DioException catch (e, s) {
      handleDioException(e, s, 'addComment(int postId, int userId, String body)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<CommentModel> updateComment(CommentModel comment) async {
    try {
      final response = await dio.patch(
        ApiEndpoints.singleComment(comment.id),
        data: {'userId': comment.user.id, 'body': comment.body},
      );
      return CommentModel.fromJson(response.data);
    } on DioException catch (e, s) {
      handleDioException(e, s, 'updateComment(CommentModel comment)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<void> deleteComment(CommentModel comment) async {
    try {
      await dio.delete(ApiEndpoints.singleComment(comment.id), data: {'userId': comment.user.id});
      return;
    } on DioException catch (e, s) {
      handleDioException(e, s, 'deleteComment(CommentModel comment)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }
}
