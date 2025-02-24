import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(LoginParams params);
  Future<AuthModel> register(RegisterParams params);
  Future<bool> verifySecret(String secret);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthModel> login(LoginParams params) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {'username': params.username, 'password': params.password},
      );

      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      handleDioException(e, 'login(LoginParams params)');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthModel> register(RegisterParams params) async {
    try {
      final response = await dio.post(
        ApiEndpoints.register,
        data: {'username': params.userName, 'email': params.email, 'password': params.password},
      );
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      handleDioException(e, 'register(RegisterParams params)');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> verifySecret(String secret) async {
    try {
      final response = await dio.post(ApiEndpoints.verify, data: {'secret': secret});
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
