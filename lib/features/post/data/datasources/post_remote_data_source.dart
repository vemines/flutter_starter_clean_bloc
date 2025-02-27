import 'package:dio/dio.dart';
import 'package:flutter_starter_clean_bloc/core/constants/enum.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/usecase/params.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts(PaginationParams params);
  Future<PostModel> getPostById(int id);
  Future<PostModel> createPost(PostModel post);
  Future<PostModel> updatePost(PostModel post);
  Future<void> deletePost(int id);
  Future<List<PostModel>> searchPosts(PaginationWithSearchParams params);
  Future<List<PostModel>> getPostsByIds(ListIdParams params);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;

  PostRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PostModel>> getAllPosts(PaginationParams params) async {
    try {
      final response = await dio.get(
        ApiEndpoints.posts,
        queryParameters: {
          '_page': params.page,
          '_limit': params.limit,
          '_sort': 'createdAt',
          '_order': params.order.getString(),
        },
      );
      List<dynamic> data = response.data;
      return data.map((e) => PostModel.fromJson(e)).toList();
    } on DioException catch (e, s) {
      handleDioException(e, s, 'getAllPosts(PaginationParams params)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await dio.get(ApiEndpoints.singlePost(id));
      return PostModel.fromJson(response.data);
    } on DioException catch (e, s) {
      handleDioException(e, s, 'getPostById(int id)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await dio.post(ApiEndpoints.posts, data: post.toJson());
      return PostModel.fromJson(response.data);
    } on DioException catch (e, s) {
      handleDioException(e, s, 'createPost(PostModel post)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<PostModel> updatePost(PostModel post) async {
    try {
      final response = await dio.put(ApiEndpoints.singlePost(post.id), data: post.toJson());
      return PostModel.fromJson(response.data);
    } on DioException catch (e, s) {
      handleDioException(e, s, 'updatePost(PostModel post)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<void> deletePost(int id) async {
    try {
      await dio.delete(ApiEndpoints.singlePost(id));
      return;
    } on DioException catch (e, s) {
      handleDioException(e, s, 'deletePost(int id)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<List<PostModel>> searchPosts(PaginationWithSearchParams params) async {
    try {
      final response = await dio.get(
        ApiEndpoints.posts,
        queryParameters: {
          'q': params.search,
          '_page': params.page,
          '_limit': params.limit,
          '_sort': 'createdAt',
          '_order': 'desc',
        },
      );
      final List<dynamic> data = response.data;
      return data.map((e) => PostModel.fromJson(e)).toList();
    } on DioException catch (e, s) {
      handleDioException(e, s, 'searchPosts(PaginationWithSearchParams params)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<List<PostModel>> getPostsByIds(ListIdParams params) async {
    try {
      final response = await dio.get(ApiEndpoints.posts, queryParameters: {'id': params.ids});
      final List<dynamic> data = response.data;
      return data.map((e) => PostModel.fromJson(e)).toList();
    } on DioException catch (e, s) {
      handleDioException(e, s, 'getPostsByIds(List<int> ids)');
    } catch (e, s) {
      throw ServerException(message: e.toString(), stackTrace: s);
    }
  }
}
