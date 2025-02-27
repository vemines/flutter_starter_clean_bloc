part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<PostEntity> posts;
  final bool hasMore;
  const PostsLoaded({required this.posts, required this.hasMore});
  @override
  List<Object> get props => [posts, hasMore];

  PostsLoaded copyWith({List<PostEntity>? posts, bool? hasMore}) {
    return PostsLoaded(
      posts: posts != null ? [...this.posts, ...posts] : this.posts,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class PostsSearchLoaded extends PostState {
  final List<PostEntity> posts;
  final bool hasMore;
  final String query;
  const PostsSearchLoaded({required this.posts, required this.hasMore, required this.query});
  @override
  List<Object> get props => [posts, hasMore, query];

  PostsLoaded copyWith({List<PostEntity>? posts, bool? hasMore}) {
    return PostsLoaded(
      posts: posts != null ? [...this.posts, ...posts] : this.posts,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class PostLoaded extends PostState {
  final PostEntity post;
  const PostLoaded({required this.post});
  @override
  List<Object> get props => [post];
}

class PostError extends PostState {
  final Failure failure;
  const PostError({required this.failure});
  @override
  List<Object> get props => [failure];
}

class PostCreated extends PostState {
  final PostEntity post;
  const PostCreated({required this.post});
  @override
  List<Object> get props => [post];
}

class PostUpdated extends PostState {
  final PostEntity post;
  const PostUpdated({required this.post});
  @override
  List<Object> get props => [post];
}

class PostDeleted extends PostState {}
