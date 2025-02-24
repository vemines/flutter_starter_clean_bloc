import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/entities/user_entity.dart';
import 'package:flutter_starter_clean_bloc/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late UserBloc bloc;
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;
  late MockGetUserByIdUseCase mockGetUserByIdUseCase;
  late MockUpdateUserUseCase mockUpdateUserUseCase;
  late MockUpdateFriendListUseCase mockUpdateFriendListUseCase;
  late MockLogService mockLogService;
  late MockBookmarkPostUseCase mockBookmarkPostUseCase;

  setUp(() {
    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
    mockGetUserByIdUseCase = MockGetUserByIdUseCase();
    mockUpdateUserUseCase = MockUpdateUserUseCase();
    mockUpdateFriendListUseCase = MockUpdateFriendListUseCase();
    mockBookmarkPostUseCase = MockBookmarkPostUseCase();
    mockLogService = MockLogService();

    bloc = UserBloc(
      getAllUsersUseCase: mockGetAllUsersUseCase,
      getUserByIdUseCase: mockGetUserByIdUseCase,
      updateUserUseCase: mockUpdateUserUseCase,
      updateFriendListUseCase: mockUpdateFriendListUseCase,
      bookmarkPostUseCase: mockBookmarkPostUseCase,
      logService: mockLogService,
    );
  });

  setUpAll(() {
    registerFallbackValue(tUserEntity);
    registerFallbackValue(tPaginationParams);
    registerFallbackValue(tUserIdParams);
    registerFallbackValue(tBookmarkPostParams);
    registerFallbackValue(tUpdateFriendListParams);
  });

  tearDown(() {
    bloc.close();
  });

  test('initialState should be UserInitial', () {
    expect(bloc.state, equals(UserInitial()));
  });

  group('GetAllUsersEvent', () {
    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UsersLoaded] when data is gotten successfully',
      build: () {
        when(() => mockGetAllUsersUseCase(any())).thenAnswer((_) async => Right(tUserEntities));
        return bloc;
      },
      act: (bloc) => bloc.add(GetAllUsersEvent()),
      expect: () => [UserLoading(), UsersLoaded(users: tUserEntities, hasMore: true)],
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UsersLoaded] with hasMore false when empty list',
      build: () {
        when(
          () => mockGetAllUsersUseCase(any()),
        ).thenAnswer((_) async => const Right(<UserEntity>[]));
        return bloc;
      },
      act: (bloc) => bloc.add(GetAllUsersEvent()),
      expect: () => [UserLoading(), const UsersLoaded(users: [], hasMore: false)],
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when getting data fails',
      build: () {
        when(() => mockGetAllUsersUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetAllUsersEvent()),
      expect: () => [UserLoading(), UserError(failure: tServerFailure)],
    );
  });

  group('LoadMoreUsersEvent', () {
    blocTest<UserBloc, UserState>(
      'should emit [UserLoadingMore, UsersLoaded] when loading more is successful',
      build: () {
        when(() => mockGetAllUsersUseCase(any())).thenAnswer((_) async => Right(tUserEntities));
        return bloc;
      },
      seed: () => UsersLoaded(users: tUserEntities, hasMore: true),
      act: (bloc) => bloc.add(LoadMoreUsersEvent()),
      expect:
          () => [UserLoading(), UsersLoaded(users: tUserEntities + tUserEntities, hasMore: true)],
    );
    blocTest<UserBloc, UserState>(
      'should emit [UserLoadingMore, UsersLoaded(hasMore: false)] when no more data',
      build: () {
        when(
          () => mockGetAllUsersUseCase(any()),
        ).thenAnswer((_) async => const Right(<UserEntity>[]));
        return bloc;
      },
      seed: () => UsersLoaded(users: tUserEntities, hasMore: true),
      act: (bloc) => bloc.add(LoadMoreUsersEvent()),
      expect: () => [UserLoading(), UsersLoaded(users: tUserEntities, hasMore: false)],
    );
    blocTest<UserBloc, UserState>(
      'should not emit anything if hasMore is already false',
      build: () => bloc,
      seed: () => UsersLoaded(users: tUserEntities, hasMore: false),
      act: (bloc) => bloc.add(LoadMoreUsersEvent()),
      expect: () => [],
    );
  });

  group('GetUserByIdEvent', () {
    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserLoaded] when get user by id is successful',
      build: () {
        when(() => mockGetUserByIdUseCase(any())).thenAnswer((_) async => Right(tUserEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(GetUserByIdEvent(id: tUserEntity.id)),
      expect: () => [UserLoading(), UserLoaded(user: tUserEntity)],
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when get user by id fails',
      build: () {
        when(() => mockGetUserByIdUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetUserByIdEvent(id: tUserEntity.id)),
      expect: () => [UserLoading(), UserError(failure: tServerFailure)],
    );
  });

  group('UpdateUserEvent', () {
    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserLoaded] when update user is successful',
      build: () {
        when(() => mockUpdateUserUseCase(any())).thenAnswer((_) async => Right(tUserEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateUserEvent(user: tUserEntity)),
      expect: () => [UserLoading(), UserLoaded(user: tUserEntity)],
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when update user fails',
      build: () {
        when(() => mockUpdateUserUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateUserEvent(user: tUserEntity)),
      expect: () => [UserLoading(), UserError(failure: tServerFailure)],
    );
  });

  group('UpdateFriendListEvent', () {
    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, FriendListUpdated] when updating friend list is successful',
      build: () {
        when(() => mockUpdateFriendListUseCase(any())).thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            UpdateFriendListEvent(
              userId: tUpdateFriendListParams.userId,
              friendIds: tUpdateFriendListParams.friendIds,
            ),
          ),
      expect: () => [UserLoading(), FriendListUpdated()],
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when updating friend list fails',
      build: () {
        when(
          () => mockUpdateFriendListUseCase(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            UpdateFriendListEvent(
              userId: tUpdateFriendListParams.userId,
              friendIds: tUpdateFriendListParams.friendIds,
            ),
          ),
      expect: () => [UserLoading(), UserError(failure: tServerFailure)],
    );
  });

  group('BookmarkPostEvent', () {
    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, BookmarkPostFinish] when bookmarking is successful',
      build: () {
        when(() => mockBookmarkPostUseCase(any())).thenAnswer((_) async => const Right(unit));
        when(() => mockGetUserByIdUseCase(any())).thenAnswer((_) async => Right(tUserEntity));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            BookmarkPostEvent(
              postId: tBookmarkPostParams.postId,
              userId: tBookmarkPostParams.userId,
              bookmarkedPostIds: tBookmarkPostParams.bookmarkedPostIds,
            ),
          ),
      expect: () => [UserLoading(), BookmarkPostFinish(user: tUserEntity)],
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when bookmarking fails',
      build: () {
        when(() => mockBookmarkPostUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            BookmarkPostEvent(
              postId: tBookmarkPostParams.postId,
              userId: tBookmarkPostParams.userId,
              bookmarkedPostIds: tBookmarkPostParams.bookmarkedPostIds,
            ),
          ),
      expect: () => [UserLoading(), UserError(failure: tServerFailure)],
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when getting user details fails',
      build: () {
        when(() => mockBookmarkPostUseCase(any())).thenAnswer((_) async => const Right(unit));
        when(() => mockGetUserByIdUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            BookmarkPostEvent(
              postId: tBookmarkPostParams.postId,
              userId: tBookmarkPostParams.userId,
              bookmarkedPostIds: tBookmarkPostParams.bookmarkedPostIds,
            ),
          ),
      expect: () => [UserLoading(), UserError(failure: tServerFailure)],
    );
  });
}
