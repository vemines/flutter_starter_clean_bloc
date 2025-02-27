import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String fullName;
  final String userName;
  final String email;
  final String avatar;
  final String cover;
  final String about;
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
    required this.cover,
    required this.about,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    userName,
    email,
    avatar,
    bookmarksId,
    friendsId,
    cover,
    about,
  ];

  UserEntity copyWith({
    int? id,
    String? fullName,
    String? userName,
    String? email,
    String? avatar,
    String? cover,
    String? about,
    List<int>? bookmarksId,
    List<int>? friendsId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      cover: avatar ?? this.cover,
      bookmarksId: bookmarksId ?? this.bookmarksId,
      friendsId: friendsId ?? this.friendsId,
      about: about ?? this.about,
    );
  }
}
