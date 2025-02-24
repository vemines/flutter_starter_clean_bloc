import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/bookmark_post_usecase.dart';
import '../../domain/usecases/update_friend_list_usecase.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getAllUsers(PaginationParams params);
  Future<UserModel> getUserById(int id);
  Future<UserModel> updateUser(UserModel user);
  Future<void> updateFriendList(UpdateFriendListParams params);
  Future<void> bookmarkPost(BookmarkPostParams params);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserModel>> getAllUsers(PaginationParams params) async {
    try {
      final response = await dio.get(
        ApiEndpoints.users,
        queryParameters: {'_page': params.page, '_limit': params.limit, '_order': 'desc'},
      );
      final data = response.data as List;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioException(e, 'getAllUsers(PaginationParams params)');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await dio.get(ApiEndpoints.singleUser(id));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      handleDioException(e, 'getUserById(int id)');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await dio.put(ApiEndpoints.singleUser(user.id), data: user.toJson());
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      handleDioException(e, 'updateUser(UserModel user)');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateFriendList(UpdateFriendListParams params) async {
    try {
      await dio.patch(
        ApiEndpoints.userFriends(params.userId),
        data: {'friendIds': params.friendIds},
      );
      return;
    } on DioException catch (e) {
      handleDioException(e, 'updateFriendList(int userId, List<int> friendIds)');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> bookmarkPost(BookmarkPostParams params) async {
    try {
      await dio.patch(
        ApiEndpoints.bookmarkPost(userId: params.userId),
        data: {'postId': params.postId},
      );
      return;
    } on DioException catch (e) {
      handleDioException(e, 'updateFriendList(int userId, List<int> friendIds)');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
