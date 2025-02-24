import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/logs.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/usecases/add_comment_usecase.dart';
import '../../domain/usecases/delete_comment_usecase.dart';
import '../../domain/usecases/get_comments_by_post_id_usecase.dart';
import '../../domain/usecases/update_comment_usecase.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetCommentsByPostIdUseCase getCommentsByPostId;
  final AddCommentUseCase addComment;
  final UpdateCommentUseCase updateComment;
  final DeleteCommentUseCase deleteComment;
  final LogService logService;

  CommentBloc({
    required this.getCommentsByPostId,
    required this.addComment,
    required this.updateComment,
    required this.deleteComment,
    required this.logService,
  }) : super(CommentInitial()) {
    on<GetCommentsEvent>(_onGetComments);
    on<AddCommentEvent>(_onAddComment);
    on<UpdateCommentEvent>(_onUpdateComment);
    on<DeleteCommentEvent>(_onDeleteComment);
  }

  void _onGetComments(GetCommentsEvent event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    final result = await getCommentsByPostId(GetCommentsParams(postId: event.postId));
    emit(
      result.fold((failure) {
        logService.w(
          '$failure occur at _onGetComments(GetCommentsEvent event, Emitter<CommentState> emit)',
        );
        return CommentError(failure: failure);
      }, (comments) => CommentsLoaded(comments: comments)),
    );
  }

  void _onAddComment(AddCommentEvent event, Emitter<CommentState> emit) async {
    final currentState = state;
    if (currentState is CommentsLoaded) {
      emit(CommentLoading());
      final result = await addComment(
        AddCommentParams(postId: event.postId, userId: event.userId, body: event.body),
      );
      emit(
        result.fold((failure) {
          logService.w(
            '$failure occur at _onGetComments(GetCommentsEvent event, Emitter<CommentState> emit)',
          );
          return CommentError(failure: failure);
        }, (comment) => CommentsLoaded(comments: [...currentState.comments, comment])),
      );
    }
  }

  void _onUpdateComment(UpdateCommentEvent event, Emitter<CommentState> emit) async {
    final currentState = state;
    if (currentState is CommentsLoaded) {
      emit(CommentLoading());
      final result = await updateComment(event.comment);
      emit(
        result.fold(
          (failure) {
            logService.w(
              '$failure occur at _onGetComments(GetCommentsEvent event, Emitter<CommentState> emit)',
            );
            return CommentError(failure: failure);
          },
          (updatedComment) {
            final updatedComments =
                currentState.comments.map((comment) {
                  return comment.id == updatedComment.id ? updatedComment : comment;
                }).toList();
            return CommentsLoaded(comments: updatedComments);
          },
        ),
      );
    }
  }

  void _onDeleteComment(DeleteCommentEvent event, Emitter<CommentState> emit) async {
    final currentState = state;
    if (currentState is CommentsLoaded) {
      emit(CommentLoading());

      final result = await deleteComment(event.comment);
      emit(
        result.fold(
          (failure) {
            logService.w(
              '$failure occur at _onGetComments(GetCommentsEvent event, Emitter<CommentState> emit)',
            );
            return CommentError(failure: failure);
          },
          (_) {
            final updatedComments =
                currentState.comments.where((comment) => comment.id != event.comment.id).toList();
            return CommentsLoaded(comments: updatedComments);
          },
        ),
      );
    }
  }
}
