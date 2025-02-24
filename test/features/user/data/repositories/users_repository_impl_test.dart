import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/user/data/repositories/user_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockUserLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockLocalDataSource = MockUserLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  setUpAll(() {
    registerFallbackValue(tBookmarkPostParams);
    registerFallbackValue(tPostIdParams);
    registerFallbackValue(tListBookmarkPostIdParams);
    registerFallbackValue(tPaginationParams);
    registerFallbackValue(tUserModel);
    registerFallbackValue(tUpdateFriendListParams);
  });

  group('getAllUsers', () {
    test('should return remote data and when call to remote source is successful', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllUsers(any())).thenAnswer((_) async => tUserModels);

      final result = await repository.getAllUsers(tPaginationParams);

      verify(() => mockRemoteDataSource.getAllUsers(tPaginationParams));
      expect(result, equals(Right(tUserModels)));
    });

    test('should return server failure when call to remote source is unsuccessful', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllUsers(any())).thenThrow(tServerException);

      final result = await repository.getAllUsers(tPaginationParams);

      expect(result, equals(Left(tServerFailure)));
    });

    test('should return NoInternetFailure when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getAllUsers(tPaginationParams);

      expect(result, equals(Left(tNoInternetFailure)));
    });
  });

  group('getUserById', () {
    test(
      'should return remote data and cache it when call to remote source is successful',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getUserById(any())).thenAnswer((_) async => tUserModel);
        when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => unit);

        final result = await repository.getUserById(tUserIdParams);

        verify(() => mockRemoteDataSource.getUserById(tUserIdParams.id));
        verify(() => mockLocalDataSource.cacheUser(tUserModel));
        expect(result, equals(Right(tUserModel)));
      },
    );

    test('should return server failure when call to remote source is unsuccessful', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUserById(any())).thenThrow(tServerException);

      final result = await repository.getUserById(tUserIdParams);

      expect(result, Left(tServerFailure));
    });

    test('should return NoInternetFailure when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getUserById(tUserIdParams);

      expect(result, equals(Left(tNoInternetFailure)));
    });
  });

  group('updateUser', () {
    test('should return updated user data and cache it on successful remote call', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.updateUser(any())).thenAnswer((_) async => tUpdateUserModel);
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => unit);

      final result = await repository.updateUser(tUpdateUserEntity);

      verify(() => mockRemoteDataSource.updateUser(tUpdateUserModel));
      verify(() => mockLocalDataSource.cacheUser(tUpdateUserModel));
      expect(result, equals(Right(tUpdateUserModel)));
    });

    test('should return server failure on unsuccessful remote call', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.updateUser(any())).thenThrow(tServerException);

      final result = await repository.updateUser(tUserEntity);

      expect(result, equals(Left(tServerFailure)));
    });

    test('should return NoInternetFailure when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.updateUser(tUserEntity);

      expect(result, Left(tNoInternetFailure));
    });
  });

  group('updateFriendList', () {
    test('should complete successfully on successful remote call', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.updateFriendList(any())).thenAnswer((_) async => unit);

      final result = await repository.updateFriendList(tUpdateFriendListParams);

      verify(() => mockRemoteDataSource.updateFriendList(tUpdateFriendListParams));
      expect(result, equals(const Right(unit)));
    });

    test('should return server failure on unsuccessful remote call', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.updateFriendList(any())).thenThrow(tServerException);

      final result = await repository.updateFriendList(tUpdateFriendListParams);

      expect(result, equals(Left(tServerFailure)));
    });

    test('should return NoInternetFailure when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.updateFriendList(tUpdateFriendListParams);

      expect(result, Left(tNoInternetFailure));
    });
  });

  group('bookmarkPost', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should check if the device is online', () async {
      when(() => mockRemoteDataSource.bookmarkPost(any())).thenAnswer((_) async => unit);
      await repository.bookmarkPost(tBookmarkPostParams);
      verify(() => mockNetworkInfo.isConnected);
    });

    test('should call remote and local data sources when online', () async {
      when(() => mockRemoteDataSource.bookmarkPost(any())).thenAnswer((_) async => unit);
      final result = await repository.bookmarkPost(tBookmarkPostParams);
      verify(() => mockRemoteDataSource.bookmarkPost(tBookmarkPostParams));
      expect(result, const Right(unit));
    });

    test('should return server failure on remote failure when online', () async {
      when(() => mockRemoteDataSource.bookmarkPost(any())).thenThrow(tServerException);
      final result = await repository.bookmarkPost(tBookmarkPostParams);
      verify(() => mockRemoteDataSource.bookmarkPost(tBookmarkPostParams));
      expect(result, Left(tServerFailure));
    });

    test('should return NoInternetFailure on local failure when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.bookmarkPost(tBookmarkPostParams);
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, Left(tNoInternetFailure));
    });
  });
}
