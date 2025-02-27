import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../core/widgets/post_item.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/post_bloc.dart';
import '../../../user/presentation/bloc/user_bloc.dart';

class BookmarkedPostsPage extends StatelessWidget {
  const BookmarkedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Posts')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (authState is AuthError) {
            return Center(child: Text('Error (Auth): ${authState.failure.message}'));
          } else if (authState is AuthLoaded) {
            final currentUser = authState.auth;

            // Fetch the *current user's* data using UserBloc.  Crucially, we listen
            // for the UserLoaded state *specifically for the current user*.
            return BlocProvider<UserBloc>(
              create:
                  (context) =>
                      sl<UserBloc>()..add(
                        GetUserByIdEvent(id: currentUser.id),
                      ), //Important: Fetch *current* user.
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  if (userState is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userState is UserError) {
                    return Center(child: Text('Error (User): ${userState.failure.message}'));
                  } else if (userState is UserLoaded) {
                    final bookmarkedPostIds = userState.user.bookmarksId;

                    // Now that we have the IDs, fetch the posts.
                    // IMPORTANT:  Use a separate BlocProvider for PostBloc here
                    // to avoid conflicts with the PostBloc in PostListPage.
                    return BlocProvider<PostBloc>(
                      create:
                          (context) =>
                              sl<PostBloc>()
                                ..add(GetBookmarkedPostsEvent(bookmarksId: bookmarkedPostIds)),
                      child: BlocBuilder<PostBloc, PostState>(
                        builder: (context, postState) {
                          if (postState is PostLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (postState is PostError) {
                            return Center(
                              child: Text('Error (Post): ${postState.failure.message}'),
                            );
                          } else if (postState is PostsLoaded) {
                            final bookmarkedPosts = postState.posts;
                            return bookmarkedPosts.isEmpty
                                ? const Center(child: Text('No bookmarked posts yet.'))
                                : ListView.builder(
                                  itemCount: bookmarkedPosts.length,
                                  itemBuilder: (context, index) {
                                    final post = bookmarkedPosts[index];
                                    return PostItem(
                                      post: bookmarkedPosts[index],
                                      callback:
                                          () => context.push('${Paths.postDetail}/${post.id}'),
                                    );
                                  },
                                );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            );
          } else {
            return const Center(child: Text('Please log in to view bookmarks.'));
          }
        },
      ),
    );
  }
}
