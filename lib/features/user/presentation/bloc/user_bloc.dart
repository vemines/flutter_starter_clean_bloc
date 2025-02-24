import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/logs.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/bookmark_post_usecase.dart';
import '../../domain/usecases/get_all_users_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../../domain/usecases/update_friend_list_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final UpdateFriendListUseCase updateFriendListUseCase;
  final BookmarkPostUseCase bookmarkPostUseCase;
  final LogService logService;

  UserBloc({
    required this.getAllUsersUseCase,
    required this.getUserByIdUseCase,
    required this.updateUserUseCase,
    required this.updateFriendListUseCase,
    required this.logService,
    required this.bookmarkPostUseCase,
  }) : super(UserInitial()) {
    on<GetAllUsersEvent>(_onGetAllUsers);
    on<GetUserByIdEvent>(_onGetUserById);
    on<UpdateUserEvent>(_onUpdateUser);
    on<UpdateFriendListEvent>(_onUpdateFriendList);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
    on<BookmarkPostEvent>(_onBookmarkPostUsers);
  }

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;

  Future<void> _onGetAllUsers(GetAllUsersEvent event, Emitter<UserState> emit) async {
    _currentPage = 1;

    _hasMore = true;
    emit(UserLoading());
    final results = await getAllUsersUseCase(PaginationParams(page: _currentPage, limit: _limit));
    emit(
      results.fold(
        (failure) {
          logService.w(
            '$failure occur at _onGetAllUsers(GetAllUsersEvent event, Emitter<UserState> emit)',
          );
          return UserError(failure: failure);
        },
        (users) {
          if (users.isEmpty) {
            _hasMore = false;
          }
          return UsersLoaded(users: users, hasMore: _hasMore);
        },
      ),
    );
  }

  Future<void> _onLoadMoreUsers(LoadMoreUsersEvent event, Emitter<UserState> emit) async {
    if (!_hasMore) return;
    final currentState = state;

    if (currentState is UsersLoaded && currentState.hasMore == true) {
      _currentPage++;
      emit(UserLoading());
      final result = await getAllUsersUseCase(PaginationParams(page: _currentPage, limit: _limit));
      emit(
        result.fold(
          (failure) {
            logService.w(
              '$failure occur at _onLoadMoreUsers(LoadMoreUsersEvent event, Emitter<UserState> emit)',
            );
            return UserError(failure: failure);
          },
          (newUsers) {
            if (newUsers.isEmpty) {
              _hasMore = false;
            }
            return UsersLoaded(users: currentState.users + newUsers, hasMore: _hasMore);
          },
        ),
      );
    }
  }

  Future<void> _onGetUserById(GetUserByIdEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await getUserByIdUseCase(IdParams(id: event.id));
    emit(
      result.fold((failure) {
        logService.w(
          '$failure occur at _onGetUserById(GetUserByIdEvent event, Emitter<UserState> emit)',
        );
        return UserError(failure: failure);
      }, (user) => UserLoaded(user: user)),
    );
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await updateUserUseCase(event.user);
    emit(
      result.fold((failure) {
        logService.w(
          '$failure occur at _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit)',
        );
        return UserError(failure: failure);
      }, (user) => UserLoaded(user: user)),
    );
  }

  Future<void> _onUpdateFriendList(UpdateFriendListEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await updateFriendListUseCase(
      UpdateFriendListParams(userId: event.userId, friendIds: event.friendIds),
    );
    emit(
      result.fold((failure) {
        logService.w(
          '$failure occur at _onUpdateFriendList(UpdateFriendListEvent event, Emitter<UserState> emit)',
        );
        return UserError(failure: failure);
      }, (_) => FriendListUpdated()),
    );
  }

  Future<void> _onBookmarkPostUsers(BookmarkPostEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await bookmarkPostUseCase(
      BookmarkPostParams(
        postId: event.postId,
        bookmarkedPostIds: event.bookmarkedPostIds,
        userId: event.userId,
      ),
    );

    await result.fold(
      (failure) {
        logService.w(
          '$failure occur at _onBookmarkPostUsers(BookmarkPostEvent event, Emitter<UserState> emit)',
        );
        emit(UserError(failure: failure));
      },
      (_) async {
        await _bookmarkPost(event.userId, emit);
      },
    );
  }

  Future<void> _bookmarkPost(int userId, Emitter<UserState> emit) async {
    final result = await getUserByIdUseCase(IdParams(id: userId));
    emit(
      result.fold((failure) {
        logService.w('$failure occur at _getUserById(int userId, Emitter<UserState> emit)');
        return UserError(failure: failure);
      }, (user) => BookmarkPostFinish(user: user)),
    );
  }
}
