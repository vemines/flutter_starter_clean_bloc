class UserApiMap {
  static const String kId = 'id';
  static const String kFullName = 'fullName';
  static const String kUserName = 'username';
  static const String kEmail = 'email';
  static const String kAvatar = 'avatar';
  static const String kSecret = 'secret';
  static const String kBookmarksId = 'bookmarkedPosts';
  static const String kFriendIds = 'friendIds';
}

class PostApiMap {
  static const String kId = 'id';
  static const String kUserId = 'userId';
  static const String kTitle = 'title';
  static const String kBody = 'body';
  static const String kImageUrl = 'imageUrl';
  static const String kcreatedAt = 'createdAt';
  static const String kUpdatedAt = 'updatedAt';
}

class CommentApiMap {
  static const String kId = 'id';
  static const String kPostId = 'postId';
  static const String kUser = 'user';
  static const String kBody = 'body';
  static const String kCreatedAt = 'createdAt';
  static const String kUpdatedAt = 'updatedAt';
}
