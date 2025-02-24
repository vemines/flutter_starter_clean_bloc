part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserEntity> users;
  final bool hasMore;

  const UsersLoaded({required this.users, required this.hasMore});

  @override
  List<Object> get props => [users, hasMore];
}

class UserLoaded extends UserState {
  final UserEntity user;

  const UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final Failure failure;

  const UserError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class FriendListUpdated extends UserState {}

class BookmarkPostFinish extends UserState {
  final UserEntity user;

  const BookmarkPostFinish({required this.user});

  @override
  List<Object> get props => [user];
}
