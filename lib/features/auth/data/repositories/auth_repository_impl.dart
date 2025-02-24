import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthEntity>> login(LoginParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAuth = await remoteDataSource.login(params);
        await localDataSource.cacheAuth(remoteAuth);
        return Right(remoteAuth);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    }
    return Left(NoInternetFailure());
  }

  @override
  Future<Either<Failure, AuthEntity>> register(RegisterParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAuth = await remoteDataSource.register(params);
        await localDataSource.cacheAuth(remoteAuth);
        return Right(remoteAuth);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    }
    return Left(NoInternetFailure());
  }

  @override
  Future<Either<Failure, AuthEntity>> getLoggedInUser() async {
    final localAuth = await localDataSource.getCachedAuth();
    if (localAuth != null) {
      return Right(localAuth);
    } else {
      return Left(NoCacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    await localDataSource.clearCachedAuth();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, bool>> verifySecret(AuthEntity auth) async {
    if (await networkInfo.isConnected) {
      try {
        final isVerified = await remoteDataSource.verifySecret(auth.secret);
        return Right(isVerified);
      } catch (e) {
        return Left(handleRepositoryException(e));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
