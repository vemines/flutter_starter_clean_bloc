// import 'package:flutter_starter_clean_bloc/features/auth/presentation/pages/login_page.dart';
// import 'package:flutter_starter_clean_bloc/features/auth/presentation/pages/register_page.dart';
// import 'package:flutter_starter_clean_bloc/features/post/presentation/pages/post_detail_page.dart';
// import 'package:flutter_starter_clean_bloc/features/post/presentation/pages/post_list_page.dart';
// import 'package:flutter_starter_clean_bloc/features/user/presentation/pages/user_profile_page.dart';
import 'package:go_router/go_router.dart';

import '../core/pages/not_found_page.dart';
// import '../core/utils/num_utils.dart';

class Paths {
  static const String posts = '/posts';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String userPosts = '/user_posts';
  static const String settings = '/settings';

  // routes have params
  static const String userProfile = '/user_profile';
  static const String postDetail = '/post_detail';
}

final routes = GoRouter(
  initialLocation: Paths.posts,
  routes: [
    // GoRoute(
    //   path: Paths.posts,
    //   builder: (context, state) => const PostListPage(), // Show Post List Page
    // ),
    // GoRoute(path: Paths.login, builder: (context, state) => const LoginPage()),
    // GoRoute(path: Paths.register, builder: (context, state) => const RegisterPage()),
    // GoRoute(
    //   path: Paths.forgotPassword,
    //   builder: (context, state) => const Scaffold(body: Center(child: Text('Forgot Password'))),
    // ),
    // GoRoute(
    //   path: '${Paths.userProfile}/:userId',
    //   builder: (context, state) {
    //     final userId = state.pathParameters['userId'];
    //     if (userId == null) {
    //       return UserProfilePage(userId: NumUtils.numParse<int>(userId));
    //     }
    //     return UserProfilePage(userId: int.parse(userId));
    //   },
    // ),
    // GoRoute(
    //   path: Paths.userPosts,
    //   builder: (context, state) => const Scaffold(body: Center(child: Text('User Posts'))),
    // ),
    // GoRoute(
    //   path: '${Paths.postDetail}/:postId',
    //   builder: (context, state) {
    //     final postId = state.pathParameters['postId'];
    //     if (postId == null) {
    //       return PostDetailPage(postId: NumUtils.numParse<int>(postId));
    //     }
    //     return PostDetailPage(postId: int.parse(postId));
    //   },
    // ),
    // GoRoute(
    //   path: '${Paths.userProfile}/:userId',
    //   builder: (context, state) {
    //     final userId = state.pathParameters['userId'];

    //     return UserProfilePage(userId: NumUtils.numParse<int>(userId));
    //   },
    // ),
    // GoRoute(
    //   path: Paths.settings,
    //   builder: (context, state) => const Scaffold(body: Center(child: Text('Settings'))),
    // ),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);
