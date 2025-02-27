import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/pagination.dart';

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
    required this.logService,
  }) : super(PostInitial()) {
    on<GetAllPostsEvent>(_onGetAllPosts);
    on<GetPostByIdEvent>(_onGetPostById);
    on<CreatePostEvent>(_onCreatePost);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
    on<SearchPostsEvent>(_onSearchPosts);
    on<GetBookmarkedPostsEvent>(_onGetBookmarkedPosts);
  }

  final _allPostPS = PaginationStorage();

  Future<void> _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit) async {
    final results = await getAllPosts(
      PaginationParams(page: _allPostPS.currentPage, limit: _allPostPS.limit),
    );

    results.fold(
      (failure) {
        logService.e(
          '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
        );
        emit(PostError(failure: failure));
      },
      (posts) {
        _handleGetListPosts(emit: emit, posts: posts, ps: _allPostPS);
      },
    );
  }

  void _handleGetListPosts({
    required List<PostEntity> posts,
    required PaginationStorage ps,
    required Emitter<PostState> emit,
  }) {
    if (posts.isEmpty) {
      ps.hasMore = false;
      if (state is PostsLoaded) {
        emit((state as PostsLoaded).copyWith(hasMore: false));
        return;
      } else {
        emit(PostsLoaded(posts: [], hasMore: false));
        return;
      }
    }

    ps.currentPage++;

    if (state is PostsLoaded) {
      emit((state as PostsLoaded).copyWith(posts: posts));
      return;
    } else {
      emit(PostsLoaded(posts: posts, hasMore: true));
      return;
    }
  }

  PaginationStorage _searchPostsPS = PaginationStorage();
  String _currentSearchQuery = '';

  Future<void> _onSearchPosts(SearchPostsEvent event, Emitter<PostState> emit) async {
    if (event.query != _currentSearchQuery) _searchPostsPS = PaginationStorage();
    _currentSearchQuery = event.query;

    final results = await searchPosts(
      PaginationWithSearchParams(
        page: _searchPostsPS.currentPage,
        limit: _searchPostsPS.limit,
        search: event.query,
      ),
    );

    results.fold(
      (failure) {
        logService.w(
          '$failure occur at _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit)',
        );
        return emit(PostError(failure: failure));
      },
      (posts) {
        _handleGetListPosts(emit: emit, posts: posts, ps: _searchPostsPS);
      },
    );
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
      }, (post) => PostLoaded(post: post)),
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
