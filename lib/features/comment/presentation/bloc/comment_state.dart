part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();
  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final List<CommentEntity> comments;
  final bool hasMore;

  const CommentsLoaded({required this.comments, required this.hasMore});

  @override
  List<Object> get props => [comments, hasMore];

  CommentsLoaded copyWith({List<CommentEntity>? comments, bool? hasMore}) {
    return CommentsLoaded(
      comments: comments != null ? [...this.comments, ...comments] : this.comments,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class CommentError extends CommentState {
  final Failure failure;

  const CommentError({required this.failure});
}
