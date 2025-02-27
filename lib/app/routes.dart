import 'package:flutter/material.dart';
import '../core/utils/utils.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/presentation/home/pages/home_page.dart';
import '../injection_container.dart';
import '../ui/components.dart';
import 'package:go_router/go_router.dart';
import '../core/pages/not_found_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/post/presentation/pages/post_detail_page.dart';
import '../features/user/presentation/pages/user_profile_page.dart';
import '../features/user/presentation/pages/user_detail_page.dart';
import '../features/post/presentation/pages/bookmarked_posts_page.dart';

class Paths {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String userPosts = '/user_posts';
  static const String settings = '/settings';
  static const String home = '/home';
  static const String bookmarkedPost = '/posts/bookmarked';

  // routes have params
  static const String userProfile = '/user_profile';
  static const String postDetail = '/post_detail';
}

final routes = GoRouter(
  initialLocation: sl<AuthBloc>().state is AuthLoaded ? Paths.home : Paths.login,
  redirect: (context, state) {
    final authBloc = sl<AuthBloc>();
    if (authBloc.state is AuthInitial) authBloc.add(GetLoggedInUserEvent());

    final isAuthenticated = authBloc.state is AuthLoaded;
    final isLoginPage = state.uri.path == Paths.login;
    return isAuthenticated && !isLoginPage ? null : Paths.login;
  },
  routes: [
    GoRoute(
      path: '${Paths.postDetail}/:postId',
      builder: (context, state) {
        final postIdParameters = state.pathParameters['postId'];
        final postId = intParse(value: postIdParameters);
        if (postId == 0) return PageNotFound();

        return PostDetailPage(postId: postId);
      },
    ),
    GoRoute(
      path: Paths.bookmarkedPost,
      builder: (context, state) {
        return BookmarkedPostsPage();
      },
    ),
    GoRoute(path: Paths.login, builder: (context, state) => const LoginPage()),
    GoRoute(path: Paths.home, builder: (context, state) => const HomePage()),
    GoRoute(path: Paths.register, builder: (context, state) => const RegisterPage()),
    GoRoute(
      path: Paths.forgotPassword,
      builder: (context, state) => const Scaffold(body: Center(child: Text('Forgot Password'))),
    ),

    GoRoute(
      path: '${Paths.userProfile}/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId'];
        final isProfile = state.extra as bool? ?? false;

        return UserProfilePage(userId: int.parse(userId!), isProfile: isProfile);
      },
    ),
    GoRoute(
      path: '${Paths.userPosts}/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId'];

        return UserDetailPage(userId: int.parse(userId!));
      },
    ),

    GoRoute(
      path: Paths.settings,
      builder: (context, state) => const Scaffold(body: Center(child: Text('Settings'))),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);
