import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/post/presentation/bloc/post_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late PostBloc bloc;
  late MockGetAllPostsUseCase mockGetAllPosts;
  late MockGetPostByIdUseCase mockGetPostById;
  late MockCreatePostUseCase mockCreatePost;
  late MockUpdatePostUseCase mockUpdatePost;
  late MockDeletePostUseCase mockDeletePost;
  late MockSearchPostsUseCase mockSearchPosts;
  late MockGetBookmarkedPostsUseCase mockGetBookmarkedPosts;
  late MockLogService mockLogService;

  setUp(() {
    mockGetAllPosts = MockGetAllPostsUseCase();
    mockGetPostById = MockGetPostByIdUseCase();
    mockCreatePost = MockCreatePostUseCase();
    mockUpdatePost = MockUpdatePostUseCase();
    mockDeletePost = MockDeletePostUseCase();
    mockSearchPosts = MockSearchPostsUseCase();
    mockGetBookmarkedPosts = MockGetBookmarkedPostsUseCase();
    mockLogService = MockLogService();

    bloc = PostBloc(
      getAllPosts: mockGetAllPosts,
      getPostById: mockGetPostById,
      createPost: mockCreatePost,
      updatePost: mockUpdatePost,
      deletePost: mockDeletePost,
      searchPosts: mockSearchPosts,
      getBookmarkedPosts: mockGetBookmarkedPosts,
      logService: mockLogService,
    );

    registerFallbackValue(tPostEntity);
    registerFallbackValue(tPaginationParams);
    registerFallbackValue(tListBookmarkPostIdParams);
    registerFallbackValue(tPostIdParams);
    registerFallbackValue(tPaginationWithSearchParams);
    // registerFallbackValue(tPostEntityUpdate);
  });

  tearDown(() {
    bloc.close();
  });

  test('initialState should be PostInitial', () {
    expect(bloc.state, equals(PostInitial()));
  });

  group('GetAllPostsEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostLoaded] on success',
      build: () {
        when(() => mockGetAllPosts(any())).thenAnswer((_) async => Right(tPostEntities));
        return bloc;
      },
      act: (bloc) => bloc.add(GetAllPostsEvent()),
      expect: () => [PostLoading(), PostsLoaded(posts: tPostEntities, hasMore: true)],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostLoaded] with hasMore false when empty list',
      build: () {
        when(() => mockGetAllPosts(any())).thenAnswer((_) async => Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(GetAllPostsEvent()),
      expect: () => [PostLoading(), PostsLoaded(posts: [], hasMore: false)],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] on failure',
      build: () {
        when(() => mockGetAllPosts(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetAllPostsEvent()),
      expect: () => [PostLoading(), PostError(failure: tServerFailure)],
    );
  });

  group('LoadMorePostsEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoadingMore, PostLoaded] on success',
      build: () {
        when(() => mockGetAllPosts(any())).thenAnswer((_) async => Right(tPostEntities));
        return bloc;
      },
      seed: () => PostsLoaded(posts: [], hasMore: true),
      act: (bloc) => bloc.add(LoadMorePostsEvent()),
      expect: () => [PostLoading(), PostsLoaded(posts: tPostEntities, hasMore: true)],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoadingMore, PostLoaded(hasMore: false)] when no more data',
      build: () {
        when(() => mockGetAllPosts(any())).thenAnswer((_) async => Right([]));
        return bloc;
      },
      seed: () => PostsLoaded(posts: [], hasMore: true),
      act: (bloc) => bloc.add(LoadMorePostsEvent()),
      expect: () => [PostLoading(), PostsLoaded(posts: [], hasMore: false)],
    );

    blocTest<PostBloc, PostState>(
      'should not emit anything if hasMore is already false',
      build: () {
        return bloc;
      },
      seed: () => PostsLoaded(posts: [], hasMore: false),
      act: (bloc) => bloc.add(LoadMorePostsEvent()),
      expect: () => [],
    );
  });

  group('GetPostByIdEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostLoaded] on success',
      build: () {
        when(() => mockGetPostById(any())).thenAnswer((_) async => Right(tPostEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(GetPostByIdEvent(id: tPostEntity.id)),
      expect: () => [PostLoading(), PostLoaded(posts: tPostEntity)],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] on failure',
      build: () {
        when(() => mockGetPostById(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetPostByIdEvent(id: tPostEntity.id)),
      expect: () => [PostLoading(), PostError(failure: tServerFailure)],
    );
  });

  group('CreatePostEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostCreated] on success',
      build: () {
        when(() => mockCreatePost(any())).thenAnswer((_) async => Right(tPostEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(CreatePostEvent(post: tPostEntity)),
      expect: () => [PostLoading(), PostCreated(post: tPostEntity)],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] on failure',
      build: () {
        when(() => mockCreatePost(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(CreatePostEvent(post: tPostEntity)),
      expect: () => [PostLoading(), PostError(failure: tServerFailure)],
    );
  });

  group('UpdatePostEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostUpdated] on success',
      build: () {
        when(() => mockUpdatePost(any())).thenAnswer((_) async => Right(tPostEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdatePostEvent(post: tPostEntity)),
      expect: () => [PostLoading(), PostUpdated(post: tPostEntity)],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] on failure',
      build: () {
        when(() => mockUpdatePost(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdatePostEvent(post: tPostEntity)),
      expect: () => [PostLoading(), PostError(failure: tServerFailure)],
    );
  });

  group('DeletePostEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostDeleted] on success',
      build: () {
        when(() => mockDeletePost(any())).thenAnswer((_) async => Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(DeletePostEvent(post: tPostEntity)),
      expect: () => [PostLoading(), PostDeleted()],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] on failure',
      build: () {
        when(() => mockDeletePost(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(DeletePostEvent(post: tPostEntity)),
      expect: () => [PostLoading(), PostError(failure: tServerFailure)],
    );
  });

  group('SearchPostsEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostLoaded] on success',
      build: () {
        when(() => mockSearchPosts(any())).thenAnswer((_) async => Right(tPostEntities));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchPostsEvent(query: tQuery)),
      expect: () => [PostLoading(), PostsLoaded(posts: tPostEntities, hasMore: true)],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostLoaded] with hasMore false when empty list',
      build: () {
        when(() => mockSearchPosts(any())).thenAnswer((_) async => Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchPostsEvent(query: tQuery)),
      expect: () => [PostLoading(), PostsLoaded(posts: [], hasMore: false)],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] on failure',
      build: () {
        when(() => mockSearchPosts(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchPostsEvent(query: tQuery)),
      expect: () => [PostLoading(), PostError(failure: tServerFailure)],
    );
  });

  group('GetBookmarkedPostsEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostLoaded] on success',
      build: () {
        when(() => mockGetBookmarkedPosts(any())).thenAnswer((_) async => Right(tPostEntities));
        return bloc;
      },
      act: (bloc) => bloc.add(GetBookmarkedPostsEvent(bookmarksId: tUserEntity.bookmarksId)),
      expect: () => [PostLoading(), PostsLoaded(posts: tPostEntities, hasMore: false)],
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] on failure',
      build: () {
        when(() => mockGetBookmarkedPosts(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetBookmarkedPostsEvent(bookmarksId: tUserEntity.bookmarksId)),
      expect: () => [PostLoading(), PostError(failure: tServerFailure)],
    );
  });
}
