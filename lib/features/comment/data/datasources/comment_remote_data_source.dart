import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/usecases/add_comment_usecase.dart';
import '../models/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getCommentsByPostId(int postId);
  Future<CommentModel> addComment(AddCommentParams params);
  Future<CommentModel> updateComment(CommentModel comment);
  Future<void> deleteComment(CommentModel comment);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final Dio dio;
  CommentRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CommentModel>> getCommentsByPostId(int postId) async {
    try {
      final response = await dio.get(ApiEndpoints.getCommentsByPostId(postId: postId));
      return (response.data as List).map((e) => CommentModel.fromJson(e)).toList();
    } on DioException catch (e) {
      handleDioException(e, 'getCommentsByPostId(int postId)');
    } catch (e) {
      throw ServerException(message: e.toString());
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
    } on DioException catch (e) {
      handleDioException(e, 'addComment(int postId, int userId, String body)');
    } catch (e) {
      throw ServerException(message: e.toString());
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
    } on DioException catch (e) {
      handleDioException(e, 'updateComment(CommentModel comment)');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteComment(CommentModel comment) async {
    try {
      await dio.delete(ApiEndpoints.singleComment(comment.id), data: {'userId': comment.user.id});
      return;
    } on DioException catch (e) {
      handleDioException(e, 'deleteComment(CommentModel comment)');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
