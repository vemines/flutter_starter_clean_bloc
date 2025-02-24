import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_starter_clean_bloc/core/errors/failures.dart';
import 'package:flutter_starter_clean_bloc/features/auth/data/repositories/auth_repository_impl.dart';

import '../../../../mocks.dart';

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    registerFallbackValue(tLoginParams);
    registerFallbackValue(tRegisterParams);
    registerFallbackValue(tAuthModel);
    registerFallbackValue(tSecret);
  });

  group('login', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenAnswer((_) async => tAuthModel);
      when(() => mockLocalDataSource.cacheAuth(any())).thenAnswer((_) async => {});
      await repository.login(tLoginParams);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should cache and return remote data on successful login', () async {
        when(() => mockRemoteDataSource.login(any())).thenAnswer((_) async => tAuthModel);
        when(() => mockLocalDataSource.cacheAuth(any())).thenAnswer((_) async => {});

        final result = await repository.login(tLoginParams);

        verify(() => mockLocalDataSource.cacheAuth(tAuthModel));
        expect(result, equals(Right(tAuthModel)));
      });

      test('should return ServerFailure on unsuccessful login', () async {
        when(() => mockRemoteDataSource.login(any())).thenThrow(tServerException);
        final result = await repository.login(tLoginParams);
        expect(result, Left(tServerFailure));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NoInternetFailure when device is offline', () async {
        final result = await repository.login(tLoginParams);
        expect(result, equals(Left(tNoInternetFailure)));
      });
    });
  });

  group('register', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.register(any())).thenAnswer((_) async => tAuthModel);
      when(() => mockLocalDataSource.cacheAuth(any())).thenAnswer((_) async => {});
      await repository.register(tRegisterParams);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should cache and return remote data on successful register', () async {
        when(() => mockRemoteDataSource.register(any())).thenAnswer((_) async => tAuthModel);
        when(() => mockLocalDataSource.cacheAuth(any())).thenAnswer((_) async => {});
        final result = await repository.register(tRegisterParams);
        verify(() => mockLocalDataSource.cacheAuth(tAuthModel));
        expect(result, equals(Right(tAuthModel))); // Compare with Auth, not AuthModel
      });

      test('should return ServerFailure on unsuccessful register', () async {
        when(() => mockRemoteDataSource.register(any())).thenThrow(tServerException);

        final result = await repository.register(tRegisterParams);

        expect(result, equals(Left(tServerFailure)));
        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NoInternetFailure when device is offline', () async {
        final result = await repository.register(tRegisterParams);
        expect(result, equals(Left(tNoInternetFailure)));
      });
    });
  });

  group('getLoggedInUser', () {
    test('should return last locally cached data when present', () async {
      when(() => mockLocalDataSource.getCachedAuth()).thenAnswer((_) async => tAuthModel);
      final result = await repository.getLoggedInUser();
      expect(result, equals(Right(tAuthModel)));
    });

    test('should return CacheFailure when no cached data', () async {
      when(() => mockLocalDataSource.getCachedAuth()).thenAnswer((_) async => null);
      final result = await repository.getLoggedInUser();
      expect(result, equals(Left(NoCacheFailure())));
    });
  });

  group('logout', () {
    test('should clear the cache and return Right(unit)', () async {
      when(() => mockLocalDataSource.clearCachedAuth()).thenAnswer((_) async => {});
      final result = await repository.logout();
      verify(() => mockLocalDataSource.clearCachedAuth());
      expect(result, equals(const Right(unit)));
    });
  });

  group('verifySecret', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getCachedAuth()).thenAnswer((_) async => tAuthModel);
      when(() => mockRemoteDataSource.verifySecret(any())).thenAnswer((_) async => true);
      await repository.verifySecret(tAuthEntity);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockLocalDataSource.getCachedAuth()).thenAnswer((_) async => tAuthModel);
      });

      test('should return true when the secret is verified successfully', () async {
        when(() => mockLocalDataSource.getCachedAuth()).thenAnswer((_) async => tAuthModel);
        when(() => mockRemoteDataSource.verifySecret(any())).thenAnswer((_) async => true);
        final result = await repository.verifySecret(tAuthEntity);
        verify(() => mockRemoteDataSource.verifySecret(tSecret));
        expect(result, const Right(true));
      });

      test('should return false when the secret verification fails', () async {
        when(() => mockRemoteDataSource.verifySecret(any())).thenAnswer((_) async => false);
        final result = await repository.verifySecret(tAuthEntity);
        expect(result, const Right(false));
      });

      test('should return ServerFailure on unsuccessful remote verification', () async {
        when(() => mockRemoteDataSource.verifySecret(any())).thenThrow(tServerException);
        final result = await repository.verifySecret(tAuthEntity);
        expect(result, equals(Left(tServerFailure)));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NoInternetFailure when device is offline', () async {
        final result = await repository.verifySecret(tAuthEntity);
        expect(result, equals(Left(tNoInternetFailure)));
      });
    });
  });
}
