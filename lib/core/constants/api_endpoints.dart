class ApiEndpoints {
  static String login = '/login';
  static String register = '/register';
  static String verify = '/verify';
  static String users = '/users';
  static String posts = '/posts';
  static String comments = '/comments';

  static String getCommentsByPostId({required int postId}) =>
      '${ApiEndpoints.posts}/$postId/comments';
  static String userFriends(int userId) => '${ApiEndpoints.users}/$userId/friends';
  static String singleComment(int id) => '${ApiEndpoints.comments}/$id}';
  static String singlePost(int id) => '${ApiEndpoints.posts}/$id';
  static String singleUser(int id) => '${ApiEndpoints.users}/$id';
  static String bookmarkPost({required int userId}) => '${ApiEndpoints.users}/$userId/bookmark';
}
