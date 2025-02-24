import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String fullName;
  final String userName;
  final String email;
  final String avatar;
  final List<int> bookmarksId;
  final List<int> friendsId;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.avatar,
    required this.bookmarksId,
    required this.friendsId,
  });

  @override
  List<Object?> get props => [id, fullName, userName, email, avatar, bookmarksId, friendsId];

  UserEntity copyWith({
    int? id,
    String? fullName,
    String? userName,
    String? email,
    String? avatar,
    List<int>? bookmarksId,
    List<int>? friendsId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      bookmarksId: bookmarksId ?? this.bookmarksId,
      friendsId: friendsId ?? this.friendsId,
    );
  }
}
