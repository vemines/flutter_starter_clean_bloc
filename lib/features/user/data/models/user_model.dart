import 'package:flutter_starter_clean_bloc/core/utils/num_utils.dart';

import '../../../../core/constants/api_mapping.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.userName,
    required super.email,
    required super.avatar,
    required super.bookmarksId,
    required super.friendsId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[UserApiMap.kId] as int,
      fullName: json[UserApiMap.kFullName] as String,
      userName: json[UserApiMap.kUserName] as String,
      email: json[UserApiMap.kEmail] as String,
      avatar: json[UserApiMap.kAvatar] as String,
      bookmarksId:
          (json[UserApiMap.kBookmarksId] as List<dynamic>).map((e) => intParse(value: e)).toList(),
      friendsId:
          (json[UserApiMap.kFriendIds] as List<dynamic>).map((e) => intParse(value: e)).toList(),
    );
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      userName: user.userName,
      email: user.email,
      avatar: user.avatar,
      bookmarksId: user.bookmarksId,
      friendsId: user.friendsId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      UserApiMap.kId: id,
      UserApiMap.kFullName: fullName,
      UserApiMap.kUserName: userName,
      UserApiMap.kEmail: email,
      UserApiMap.kAvatar: avatar,
      UserApiMap.kBookmarksId: bookmarksId,
      UserApiMap.kFriendIds: friendsId,
    };
  }

  @override
  UserModel copyWith({
    int? id,
    String? fullName,
    String? userName,
    String? email,
    String? avatar,
    List<int>? bookmarksId,
    List<int>? friendsId,
  }) {
    return UserModel(
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
