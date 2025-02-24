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

  const CommentsLoaded({required this.comments});
  @override
  List<Object?> get props => [comments];
}

class CommentError extends CommentState {
  final Failure failure;

  const CommentError({required this.failure});
  @override
  List<Object?> get props => [failure];
}
