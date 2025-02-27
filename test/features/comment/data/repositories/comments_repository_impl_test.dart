import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/comment/data/models/comment_model.dart';
import 'package:flutter_starter_clean_bloc/features/comment/data/repositories/comment_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late CommentRepositoryImpl repository;
  late MockCommentRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCommentRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CommentRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  setUpAll(() {
    registerFallbackValue(tAddCommentParams);
    registerFallbackValue(tCommentModel);
  });

  group('getCommentsByPostId', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.getCommentsByPostId(any()),
      ).thenAnswer((_) async => tCommentModels);
      await repository.getCommentsByPostId(tGetCommentsParams);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data on successful call', () async {
        when(
          () => mockRemoteDataSource.getCommentsByPostId(any()),
        ).thenAnswer((_) async => tCommentModels);
        final result = await repository.getCommentsByPostId(tGetCommentsParams);
        verify(() => mockRemoteDataSource.getCommentsByPostId(tGetCommentsParams));
        expect(result, equals(Right(tCommentModels)));
      });

      test('should return server failure on unsuccessful call', () async {
        when(() => mockRemoteDataSource.getCommentsByPostId(any())).thenThrow(tServerException);
        final result = await repository.getCommentsByPostId(tGetCommentsParams);
        verify(() => mockRemoteDataSource.getCommentsByPostId(tGetCommentsParams));
        expect(result, equals(Left(tServerFailure)));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NoInternetFailure when offline', () async {
        final result = await repository.getCommentsByPostId(tGetCommentsParams);
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Left(tNoInternetFailure)));
      });
    });
  });

  group('addComment', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.addComment(any())).thenAnswer((_) async => tCommentModel);
      await repository.addComment(tAddCommentParams);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return newly created comment on successful call', () async {
        when(() => mockRemoteDataSource.addComment(any())).thenAnswer((_) async => tCommentModel);
        final result = await repository.addComment(tAddCommentParams);
        verify(() => mockRemoteDataSource.addComment(tAddCommentParams));
        expect(result, Right(tCommentModel));
      });

      test('should return server failure on unsuccessful call', () async {
        when(() => mockRemoteDataSource.addComment(any())).thenThrow(tServerException);
        final result = await repository.addComment(tAddCommentParams);
        verify(() => mockRemoteDataSource.addComment(tAddCommentParams));
        expect(result, Left(tServerFailure));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NoInternetFailure when device is offline', () async {
        final result = await repository.addComment(tAddCommentParams);
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, Left(tNoInternetFailure));
      });
    });
  });

  group('updateComment', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.updateComment(any())).thenAnswer((_) async => tCommentModel);
      await repository.updateComment(tCommentEntity);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return updated comment on successful call', () async {
        when(
          () => mockRemoteDataSource.updateComment(any()),
        ).thenAnswer((_) async => tCommentModel);
        final result = await repository.updateComment(tCommentEntity);
        verify(() => mockRemoteDataSource.updateComment(any(that: isA<CommentModel>())));
        expect(result, Right(tCommentModel));
      });

      test('should return server failure on unsuccessful call', () async {
        when(() => mockRemoteDataSource.updateComment(any())).thenThrow(tServerException);
        final result = await repository.updateComment(tCommentEntity);
        verify(() => mockRemoteDataSource.updateComment(any(that: isA<CommentModel>())));
        expect(result, Left(tServerFailure));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NoInternetFailure when device is offline', () async {
        final result = await repository.updateComment(tCommentEntity);
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, Left(tNoInternetFailure));
      });
    });
  });

  group('deleteComment', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.deleteComment(any())).thenAnswer((_) async => Future.value());
      await repository.deleteComment(tCommentEntity);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return null on successful call', () async {
        when(
          () => mockRemoteDataSource.deleteComment(any()),
        ).thenAnswer((_) async => Future.value());
        final result = await repository.deleteComment(tCommentEntity);
        verify(() => mockRemoteDataSource.deleteComment(tCommentModel));
        expect(result, const Right(null));
      });

      test('should return server failure on unsuccessful call', () async {
        when(() => mockRemoteDataSource.deleteComment(any())).thenThrow(tServerException);
        final result = await repository.deleteComment(tCommentEntity);
        verify(() => mockRemoteDataSource.deleteComment(tCommentModel));
        expect(result, Left(tServerFailure));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NoInternetFailure when device is offline', () async {
        final result = await repository.deleteComment(tCommentEntity);
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, Left(tNoInternetFailure));
      });
    });
  });
}
