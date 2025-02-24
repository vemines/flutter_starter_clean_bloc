import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/logs.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/params.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/get_all_posts_usecase.dart';
import '../../domain/usecases/get_bookmarked_posts_usecase.dart';
import '../../domain/usecases/get_post_by_id_usecase.dart';
import '../../domain/usecases/search_posts_usecase.dart';
import '../../domain/usecases/update_post_usecase.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetAllPostsUseCase getAllPosts;
  final GetPostByIdUseCase getPostById;
  final CreatePostUseCase createPost;
  final UpdatePostUseCase updatePost;
  final DeletePostUseCase deletePost;
  final SearchPostsUseCase searchPosts;
  final GetBookmarkedPostsUseCase getBookmarkedPosts;
  final LogService logService;
  PostBloc({
    required this.getAllPosts,
    required this.getPostById,
    required this.createPost,
    required this.updatePost,
    required this.deletePost,
    required this.searchPosts,
    required this.getBookmarkedPosts,
    // required this.bookmarkPost,
    required this.logService,
  }) : super(PostInitial()) {
    on<GetAllPostsEvent>(_onGetAllPosts);
    on<GetPostByIdEvent>(_onGetPostById);
    on<CreatePostEvent>(_onCreatePost);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
    on<SearchPostsEvent>(_onSearchPosts);
    on<GetBookmarkedPostsEvent>(_onGetBookmarkedPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
  }

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;

  Future<void> _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit) async {
    _currentPage = 1;
    _hasMore = true;
    emit(PostLoading());
    final results = await getAllPosts(PaginationParams(page: _currentPage, limit: _limit));
    emit(
      results.fold(
        (failure) {
          logService.w(
            '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
          );
          return PostError(failure: failure);
        },
        (posts) {
          if (posts.isEmpty) {
            _hasMore = false;
          }
          return PostsLoaded(posts: posts, hasMore: _hasMore);
        },
      ),
    );
  }

  Future<void> _onLoadMorePosts(LoadMorePostsEvent event, Emitter<PostState> emit) async {
    if (!_hasMore) return;

    final currentState = state;
    if (currentState is PostsLoaded && currentState.hasMore == true) {
      _currentPage++;
      emit(PostLoading());
      final results = await getAllPosts(PaginationParams(page: _currentPage, limit: _limit));
      results.fold(
        (failure) {
          logService.w(
            '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
          );
          return PostError(failure: failure);
        },
        (newPosts) {
          if (newPosts.isEmpty) {
            _hasMore = false;
          }
          emit(PostsLoaded(posts: currentState.posts + newPosts, hasMore: _hasMore));
        },
      );
    }
  }

  Future<void> _onGetPostById(GetPostByIdEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final result = await getPostById(IdParams(id: event.id));

    emit(
      result.fold((failure) {
        logService.w(
          '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
        );
        return PostError(failure: failure);
      }, (post) => PostLoaded(posts: post)),
    );
  }

  Future<void> _onCreatePost(CreatePostEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final result = await createPost(event.post);
    emit(
      result.fold((failure) {
        logService.w(
          '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
        );
        return PostError(failure: failure);
      }, (post) => PostCreated(post: post)),
    );
  }

  Future<void> _onUpdatePost(UpdatePostEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final result = await updatePost(event.post);
    emit(
      result.fold((failure) {
        logService.w(
          '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
        );
        return PostError(failure: failure);
      }, (post) => PostUpdated(post: post)),
    );
  }

  Future<void> _onDeletePost(DeletePostEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final result = await deletePost(event.post);
    emit(
      result.fold((failure) {
        logService.w(
          '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
        );
        return PostError(failure: failure);
      }, (_) => PostDeleted()),
    );
  }

  Future<void> _onSearchPosts(SearchPostsEvent event, Emitter<PostState> emit) async {
    _currentPage = 1;

    _hasMore = true;
    emit(PostLoading());
    final results = await searchPosts(
      PaginationWithSearchParams(page: _currentPage, limit: _limit, search: event.query),
    );
    emit(
      results.fold(
        (failure) {
          logService.w(
            '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
          );
          return PostError(failure: failure);
        },
        (posts) {
          if (posts.isEmpty) {
            _hasMore = false;
          }
          return PostsLoaded(posts: posts, hasMore: _hasMore);
        },
      ),
    );
  }

  Future<void> _onGetBookmarkedPosts(GetBookmarkedPostsEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final results = await getBookmarkedPosts(ListIdParams(ids: event.bookmarksId));
    emit(
      results.fold((failure) {
        logService.w(
          '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
        );
        return PostError(failure: failure);
      }, (posts) => PostsLoaded(posts: posts, hasMore: false)),
    );
  }
}
