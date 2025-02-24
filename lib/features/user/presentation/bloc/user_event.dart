part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetAllUsersEvent extends UserEvent {}

class LoadMoreUsersEvent extends UserEvent {}

class GetUserByIdEvent extends UserEvent {
  final int id;

  const GetUserByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateUserEvent extends UserEvent {
  final UserEntity user;

  const UpdateUserEvent({required this.user});
  @override
  List<Object> get props => [user];
}

class UpdateFriendListEvent extends UserEvent {
  final int userId;
  final List<int> friendIds;
  const UpdateFriendListEvent({required this.userId, required this.friendIds});
  @override
  List<Object> get props => [userId, friendIds];
}

class BookmarkPostEvent extends UserEvent {
  final int userId;
  final int postId;
  final List<int> bookmarkedPostIds;

  const BookmarkPostEvent({
    required this.userId,
    required this.postId,
    required this.bookmarkedPostIds,
  });

  @override
  List<Object> get props => [userId, postId, bookmarkedPostIds];
}
