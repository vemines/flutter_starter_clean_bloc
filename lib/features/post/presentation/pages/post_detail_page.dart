// lib/features/post/presentation/pages/post_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_clean_bloc/core/extensions/build_content_extensions.dart';
import 'package:flutter_starter_clean_bloc/core/extensions/scroll_controller.dart';
import 'package:flutter_starter_clean_bloc/core/extensions/widget_extensions.dart';
import 'package:flutter_starter_clean_bloc/core/widgets/post_item.dart';
import 'package:flutter_starter_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart'; // Import AuthBloc
import 'package:flutter_starter_clean_bloc/features/comment/domain/entities/comment_entity.dart';
import 'package:flutter_starter_clean_bloc/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:flutter_starter_clean_bloc/features/post/presentation/bloc/post_bloc.dart';
import 'package:flutter_starter_clean_bloc/features/post/presentation/widgets/comment_item.dart';
import 'package:flutter_starter_clean_bloc/injection_container.dart';

import '../../../../core/widgets/layout.dart';

class PostDetailPage extends StatefulWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late PostBloc _postBloc;
  late CommentBloc _commentBloc;
  bool _loadingComments = false;

  @override
  void initState() {
    super.initState();
    _postBloc = sl<PostBloc>()..add(GetPostByIdEvent(id: widget.postId));
    _commentBloc = sl<CommentBloc>()..add(GetCommentsEvent(postId: widget.postId));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_loadingComments) return;

    if (_scrollController.isBottom) {
      _loadingComments = true;
      _commentBloc.add(GetCommentsEvent(postId: widget.postId));
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _postBloc.close();
    _commentBloc.close();
    super.dispose();
  }

  void _addComment(int userId) {
    if (_commentController.text.trim().isNotEmpty) {
      _commentBloc.add(
        AddCommentEvent(postId: widget.postId, userId: userId, body: _commentController.text),
      );
      _commentController.clear();
    }
  }

  void _showEditDialog(CommentEntity comment) {
    String editedComment = comment.body;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Comment"),
          content: SizedBox(
            width: 500,
            child: TextFormField(
              initialValue: editedComment,
              maxLines: 4,
              decoration: const InputDecoration(hintText: "Update your comment"),
              onChanged: (value) {
                editedComment = value;
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                _commentBloc.add(
                  UpdateCommentEvent(comment: comment.copyWith(body: editedComment)),
                );
                Navigator.of(context).pop();
              },
              child: const Text("Update Post"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(CommentEntity comment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Comment"),
          content: SizedBox(
            width: 500,
            child: const Text("Are you sure you want to delete this comment?"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                _commentBloc.add(DeleteCommentEvent(comment: comment));
                Navigator.of(context).pop();
              },
              child: const Text("Delete Post"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: safeWrapContainer(
        context,
        _scrollController,
        border: Border.all(color: Colors.black26),
        MultiBlocProvider(
          providers: [
            BlocProvider<PostBloc>(create: (_) => _postBloc),
            BlocProvider<CommentBloc>(create: (_) => _commentBloc),
          ],
          child: BlocBuilder<PostBloc, PostState>(
            builder: (_, postState) {
              if (postState is PostInitial || postState is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (postState is PostError) {
                return Center(child: Text('Error: ${postState.failure.message}'));
              } else if (postState is PostLoaded) {
                final post = postState.post;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PostItem(post: post, isDetail: true, key: post.key),

                    BlocBuilder<CommentBloc, CommentState>(
                      builder: (_, commentState) {
                        if (commentState is CommentInitial) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (commentState is CommentError) {
                          return Center(child: Text('Error: ${commentState.failure.message}'));
                        } else if (commentState is CommentsLoaded) {
                          _loadingComments = false;

                          return _buildCommentsSection(commentState.comments, commentState.hasMore);
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection(List<CommentEntity> listComment, bool hasMore) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          16.sbH(),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoaded) {
                final currentUser = state.auth;
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // Pass the user ID to the _addComment function.
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _addComment(currentUser.id),
                    ),
                  ],
                );
              } else {
                return Center(child: const Text("Login to add comments."));
              }
            },
          ),
          16.sbH(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listComment.length + 1,
            itemBuilder: (context, index) {
              if (index < listComment.length) {
                final comment = listComment[index];
                // Check if the current user is the author of the comment
                return BlocBuilder<AuthBloc, AuthState>(
                  builder: (_, authState) {
                    bool isMyComment = false;
                    if (authState is AuthLoaded) {
                      isMyComment = comment.user.id == authState.auth.id;
                    }

                    return CommentItem(
                      comment: comment,
                      isMyComment: isMyComment,
                      onEdit: () => _showEditDialog(comment),
                      onDelete: () => _showDeleteDialog(comment),
                    );
                  },
                );
              } else {
                return hasMore
                    ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                    : Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: Text(
                          "No More Comments",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
              }
            },
          ),
        ],
      ),
    );
  }
}
