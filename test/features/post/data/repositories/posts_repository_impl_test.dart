import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/core/errors/exceptions.dart';
import 'package:flutter_starter_clean_bloc/core/errors/failures.dart';
import 'package:flutter_starter_clean_bloc/features/post/data/repositories/post_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late PostRepositoryImpl repository;
  late MockPostRemoteDataSource mockRemoteDataSource;
  late MockPostLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    mockLocalDataSource = MockPostLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PostRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(tPostModel);
    registerFallbackValue(tPaginationParams);
    registerFallbackValue(tPaginationWithSearchParams);
    registerFallbackValue(tListBookmarkPostIdParams);
  });

  group('getAllPosts', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllPosts(any())).thenAnswer((_) async => tPostModels);
      when(() => mockLocalDataSource.cachePosts(any())).thenAnswer((_) async => unit);

      await repository.getAllPosts(tPaginationParams);

      verify(() => mockNetworkInfo.isConnected);
    });

    group('when device online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data and cache it on successful call', () async {
        when(() => mockRemoteDataSource.getAllPosts(any())).thenAnswer((_) async => tPostModels);
        when(() => mockLocalDataSource.cachePosts(any())).thenAnswer((_) async => unit);

        final result = await repository.getAllPosts(tPaginationParams);

        verify(() => mockRemoteDataSource.getAllPosts(tPaginationParams));
        verify(() => mockLocalDataSource.cachePosts(tPostModels));
        expect(result, equals(Right(tPostModels)));
      });

      test('should return server failure on unsuccessful call', () async {
        when(() => mockRemoteDataSource.getAllPosts(any())).thenThrow(tServerException);

        final result = await repository.getAllPosts(tPaginationParams);

        verify(() => mockRemoteDataSource.getAllPosts(tPaginationParams));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(tServerFailure)));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last locally cached data when present', () async {
        when(() => mockLocalDataSource.getCachedPosts()).thenAnswer((_) async => tPostModels);
        final result = await repository.getAllPosts(tPaginationParams);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getCachedPosts());
        expect(result, equals(Right(tPostModels)));
      });

      test('should return CacheFailure when no cached data present', () async {
        when(() => mockLocalDataSource.getCachedPosts()).thenThrow(CacheException());
        final result = await repository.getAllPosts(tPaginationParams);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getCachedPosts());
        expect(result, equals(Left(NoCacheFailure())));
      });
    });
  });

  group('getPostById', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getPostById(any())).thenAnswer((_) async => tPostModel);
      await repository.getPostById(tPostIdParams);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data on successful call', () async {
        when(() => mockRemoteDataSource.getPostById(any())).thenAnswer((_) async => tPostModel);
        final result = await repository.getPostById(tPostIdParams);
        verify(() => mockRemoteDataSource.getPostById(tPostIdParams.id));
        expect(result, equals(Right(tPostModel)));
      });

      test('should return server failure on unsuccessful call', () async {
        when(() => mockRemoteDataSource.getPostById(any())).thenThrow(tServerException);
        final result = await repository.getPostById(tPostIdParams);
        verify(() => mockRemoteDataSource.getPostById(tPostIdParams.id));
        expect(result, Left(tServerFailure));
      });
    });
  });

  group('createPost', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should check if the device is online', () async {
      when(() => mockRemoteDataSource.createPost(any())).thenAnswer((_) async => tPostModel);
      await repository.createPost(tPostModel);
      verify(() => mockNetworkInfo.isConnected);
    });

    test('should return newly created post on successful call', () async {
      when(() => mockRemoteDataSource.createPost(any())).thenAnswer((_) async => tPostModel);
      final result = await repository.createPost(tPostModel);
      verify(() => mockRemoteDataSource.createPost(tPostModel));
      expect(result, equals(Right(tPostModel)));
    });

    test('should return server failure on unsuccessful call', () async {
      when(() => mockRemoteDataSource.createPost(any())).thenThrow(tServerException);
      final result = await repository.createPost(tPostModel);
      verify(() => mockRemoteDataSource.createPost(tPostModel));
      expect(result, Left(tServerFailure));
    });

    test('should return NoInternetFailure when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.createPost(tPostModel);
      verify(() => mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, Left(tNoInternetFailure));
    });
  });

  group('updatePost', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should check if the device is online', () async {
      when(() => mockRemoteDataSource.updatePost(any())).thenAnswer((_) async => tPostModel);
      await repository.updatePost(tPostModel);
      verify(() => mockNetworkInfo.isConnected);
    });

    test('should return updated post on successful call', () async {
      when(() => mockRemoteDataSource.updatePost(any())).thenAnswer((_) async => tPostModel);
      final result = await repository.updatePost(tPostModel);
      verify(() => mockRemoteDataSource.updatePost(tPostModel));
      expect(result, equals(Right(tPostModel)));
    });

    test('should return server failure on unsuccessful call', () async {
      when(() => mockRemoteDataSource.updatePost(any())).thenThrow(tServerException);
      final result = await repository.updatePost(tPostEntity);
      verify(() => mockRemoteDataSource.updatePost(tPostModel));
      expect(result, Left(tServerFailure));
    });

    test('should return NoInternetFailure when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.updatePost(tPostModel);
      verify(() => mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, Left(tNoInternetFailure));
    });
  });

  group('deletePost', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should check if the device is online', () async {
      when(() => mockRemoteDataSource.deletePost(any())).thenAnswer((_) async => unit);
      await repository.deletePost(tPostEntity);
      verify(() => mockNetworkInfo.isConnected);
    });

    test('should return null on successful call', () async {
      when(() => mockRemoteDataSource.deletePost(any())).thenAnswer((_) async => unit);
      final result = await repository.deletePost(tPostEntity);
      verify(() => mockRemoteDataSource.deletePost(tPostEntity.id));
      expect(result, const Right(null));
    });

    test('should return server failure on unsuccessful call', () async {
      when(() => mockRemoteDataSource.deletePost(any())).thenThrow(tServerException);
      final result = await repository.deletePost(tPostEntity);
      verify(() => mockRemoteDataSource.deletePost(tPostEntity.id));
      expect(result, Left(tServerFailure));
    });

    test('should return NoInternetFailure when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.deletePost(tPostEntity);
      verify(() => mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, Left(tNoInternetFailure));
    });
  });

  group('searchPosts', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should check if the device is online', () async {
      when(() => mockRemoteDataSource.searchPosts(any())).thenAnswer((_) async => tPostModels);
      await repository.searchPosts(tPaginationWithSearchParams);
      verify(() => mockNetworkInfo.isConnected);
    });

    test('should return remote data on successful call', () async {
      when(() => mockRemoteDataSource.searchPosts(any())).thenAnswer((_) async => tPostModels);
      final result = await repository.searchPosts(tPaginationWithSearchParams);
      verify(() => mockRemoteDataSource.searchPosts(tPaginationWithSearchParams));
      expect(result, Right(tPostModels));
    });

    test('should return server failure on unsuccessful call', () async {
      when(() => mockRemoteDataSource.searchPosts(any())).thenThrow(tServerException);
      final result = await repository.searchPosts(tPaginationWithSearchParams);
      verify(() => mockRemoteDataSource.searchPosts(tPaginationWithSearchParams));
      expect(result, Left(tServerFailure));
    });

    test('should return NoInternetFailure when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.searchPosts(tPaginationWithSearchParams);
      verify(() => mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, Left(tNoInternetFailure));
    });
  });

  group('getBookmarkedPosts', () {
    test('should return remote data on successful call when online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getPostsByIds(any())).thenAnswer((_) async => tPostModels);
      final result = await repository.getBookmarkedPosts(tListBookmarkPostIdParams);
      verify(() => mockRemoteDataSource.getPostsByIds(tListBookmarkPostIdParams));
      expect(result, Right(tPostModels));
    });

    test('should return server failure on unsuccessful remote call when online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getPostsByIds(any())).thenThrow(tServerException);
      final result = await repository.getBookmarkedPosts(tListBookmarkPostIdParams);
      verify(() => mockRemoteDataSource.getPostsByIds(tListBookmarkPostIdParams));
      expect(result, Left(tServerFailure));
    });
  });
}
