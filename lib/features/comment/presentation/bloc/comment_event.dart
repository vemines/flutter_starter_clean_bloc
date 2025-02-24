part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
  @override
  List<Object?> get props => [];
}

class GetCommentsEvent extends CommentEvent {
  final int postId;
  const GetCommentsEvent({required this.postId});
  @override
  List<Object?> get props => [postId];
}

class AddCommentEvent extends CommentEvent {
  final int postId;
  final int userId;
  final String body;

  const AddCommentEvent({required this.postId, required this.userId, required this.body});
  @override
  List<Object?> get props => [postId, userId, body];
}

class UpdateCommentEvent extends CommentEvent {
  final CommentEntity comment;

  const UpdateCommentEvent({required this.comment});
  @override
  List<Object?> get props => [comment];
}

class DeleteCommentEvent extends CommentEvent {
  final CommentEntity comment;

  const DeleteCommentEvent({required this.comment});
  @override
  List<Object?> get props => [comment];
}
