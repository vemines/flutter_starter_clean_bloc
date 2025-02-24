import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late CommentBloc bloc;
  late MockGetCommentsByPostIdUseCase mockGetCommentsByPostId;
  late MockAddCommentUseCase mockAddComment;
  late MockUpdateCommentUseCase mockUpdateComment;
  late MockDeleteCommentUseCase mockDeleteComment;
  late MockLogService mockLogService;

  setUp(() {
    mockGetCommentsByPostId = MockGetCommentsByPostIdUseCase();
    mockAddComment = MockAddCommentUseCase();
    mockUpdateComment = MockUpdateCommentUseCase();
    mockDeleteComment = MockDeleteCommentUseCase();
    mockLogService = MockLogService();

    bloc = CommentBloc(
      getCommentsByPostId: mockGetCommentsByPostId,
      addComment: mockAddComment,
      updateComment: mockUpdateComment,
      deleteComment: mockDeleteComment,
      logService: mockLogService,
    );
    registerFallbackValue(tGetCommentsParams);
    registerFallbackValue(tAddCommentParams);
    registerFallbackValue(tCommentEntity);
  });
  tearDown(() {
    bloc.close();
  });

  test('initialState should be CommentInitial', () {
    expect(bloc.state, equals(CommentInitial()));
  });

  group('GetCommentsEvent', () {
    blocTest<CommentBloc, CommentState>(
      'should emit [CommentLoading, CommentLoaded] when data is gotten successfully',
      build: () {
        when(() => mockGetCommentsByPostId(any())).thenAnswer((_) async => Right(tCommentEntities));
        return bloc;
      },
      act: (bloc) => bloc.add(GetCommentsEvent(postId: tPostEntity.id)),
      expect: () => [CommentLoading(), CommentsLoaded(comments: tCommentEntities)],
    );

    blocTest<CommentBloc, CommentState>(
      'should emit [CommentLoading, CommentError] when getting data fails',
      build: () {
        when(() => mockGetCommentsByPostId(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetCommentsEvent(postId: tPostEntity.id)),
      expect: () => [CommentLoading(), CommentError(failure: tServerFailure)],
    );
  });
  group('AddCommentEvent', () {
    blocTest<CommentBloc, CommentState>(
      'should emit [CommentLoading, CommentLoaded] with new comment when adding is successful',
      build: () {
        when(() => mockAddComment(any())).thenAnswer((_) async => Right(tCommentEntity));
        return bloc;
      },
      seed: () => const CommentsLoaded(comments: []),
      act:
          (bloc) => bloc.add(AddCommentEvent(postId: tPostEntity.id, userId: 1, body: 'Test Body')),
      expect:
          () => [
            CommentLoading(),
            CommentsLoaded(comments: [tCommentEntity]),
          ],
    );

    blocTest<CommentBloc, CommentState>(
      'should emit [CommentError] when adding comment fails',
      build: () {
        when(() => mockAddComment(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      seed: () => const CommentsLoaded(comments: []),
      act:
          (bloc) => bloc.add(AddCommentEvent(postId: tPostEntity.id, userId: 1, body: 'Test Body')),
      expect: () => [CommentLoading(), CommentError(failure: tServerFailure)],
    );
  });

  group('UpdateCommentEvent', () {
    blocTest<CommentBloc, CommentState>(
      'should emit [CommentLoading, CommentLoaded] with updated comment',
      build: () {
        when(() => mockUpdateComment(any())).thenAnswer((_) async => Right(tCommentEntity));
        return bloc;
      },
      seed: () => CommentsLoaded(comments: [tCommentEntity]),
      act: (bloc) => bloc.add(UpdateCommentEvent(comment: tCommentEntity)),
      expect:
          () => [
            CommentLoading(),
            CommentsLoaded(comments: [tCommentEntity]),
          ],
    );

    blocTest<CommentBloc, CommentState>(
      'should emit [CommentError] when updating comment fails',
      build: () {
        when(() => mockUpdateComment(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      seed: () => CommentsLoaded(comments: [tCommentEntity]),
      act: (bloc) => bloc.add(UpdateCommentEvent(comment: tCommentEntity)),
      expect: () => [CommentLoading(), CommentError(failure: tServerFailure)],
    );
  });

  group('DeleteCommentEvent', () {
    blocTest<CommentBloc, CommentState>(
      'should emit [CommentLoading, CommentLoaded] with comment removed',
      build: () {
        when(() => mockDeleteComment(any())).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => CommentsLoaded(comments: [tCommentEntity]),
      act: (bloc) => bloc.add(DeleteCommentEvent(comment: tCommentEntity)),
      expect: () => [CommentLoading(), const CommentsLoaded(comments: [])],
    );

    blocTest<CommentBloc, CommentState>(
      'should emit [CommentError] when deleting comment fails',
      build: () {
        when(() => mockDeleteComment(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      seed: () => CommentsLoaded(comments: [tCommentEntity]),
      act: (bloc) => bloc.add(DeleteCommentEvent(comment: tCommentEntity)),
      expect: () => [CommentLoading(), CommentError(failure: tServerFailure)],
    );
  });
}
