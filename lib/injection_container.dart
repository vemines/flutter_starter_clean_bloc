import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'features/comment/presentation/bloc/comment_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/flavor.dart';
import 'app/logs.dart';
import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_logged_in_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/verify_secret_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/comment/data/datasources/comment_remote_data_source.dart';
import 'features/comment/data/repositories/comment_repository_impl.dart';
import 'features/comment/domain/repositories/comment_repository.dart';
import 'features/comment/domain/usecases/add_comment_usecase.dart';
import 'features/comment/domain/usecases/delete_comment_usecase.dart';
import 'features/comment/domain/usecases/get_comments_by_post_id_usecase.dart';
import 'features/comment/domain/usecases/update_comment_usecase.dart';
import 'features/post/data/datasources/post_local_data_source.dart';
import 'features/post/data/datasources/post_remote_data_source.dart';
import 'features/post/data/repositories/post_repository_impl.dart';
import 'features/post/domain/repositories/post_repository.dart';
import 'features/user/domain/usecases/bookmark_post_usecase.dart';
import 'features/post/domain/usecases/create_post_usecase.dart';
import 'features/post/domain/usecases/delete_post_usecase.dart';
import 'features/post/domain/usecases/get_all_posts_usecase.dart';
import 'features/post/domain/usecases/get_bookmarked_posts_usecase.dart';
import 'features/post/domain/usecases/get_post_by_id_usecase.dart';
import 'features/post/domain/usecases/search_posts_usecase.dart';
import 'features/post/domain/usecases/update_post_usecase.dart';
import 'features/post/presentation/bloc/post_bloc.dart';
import 'features/user/data/datasources/user_local_data_source.dart';
import 'features/user/data/datasources/user_remote_data_source.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/domain/usecases/get_all_users_usecase.dart';
import 'features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'features/user/domain/usecases/update_friend_list_usecase.dart';
import 'features/user/domain/usecases/update_user_usecase.dart';
import 'features/user/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  // Bloc
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getLoggedInUserUseCase: sl(),
      logoutUseCase: sl(),
      verifySecretUseCase: sl(),
      logService: sl(),
    ),
  );
  sl.registerFactory(
    () => PostBloc(
      getAllPosts: sl(),
      getPostById: sl(),
      createPost: sl(),
      updatePost: sl(),
      deletePost: sl(),
      searchPosts: sl(),
      getBookmarkedPosts: sl(),
      logService: sl(),
    ),
  );
  sl.registerFactory(
    () => UserBloc(
      getAllUsersUseCase: sl(),
      getUserByIdUseCase: sl(),
      updateUserUseCase: sl(),
      updateFriendListUseCase: sl(),
      bookmarkPostUseCase: sl(),
      logService: sl(),
    ),
  );
  sl.registerFactory(
    () => CommentBloc(
      addComment: sl(),
      deleteComment: sl(),
      getCommentsByPostId: sl(),
      updateComment: sl(),
      logService: sl(),
    ),
  );

  // Use cases
  // -- Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetLoggedInUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => VerifySecretUseCase(sl()));

  // -- Post
  sl.registerLazySingleton(() => GetAllPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetPostByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => SearchPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetBookmarkedPostsUseCase(sl()));
  sl.registerLazySingleton(() => BookmarkPostUseCase(sl()));

  // -- User
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetUserByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFriendListUseCase(sl()));

  // -- Comment
  sl.registerLazySingleton(() => GetCommentsByPostIdUseCase(sl()));
  sl.registerLazySingleton(() => AddCommentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(secureStorage: sl()));
  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<PostLocalDataSource>(
    () => PostLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<CommentRemoteDataSource>(() => CommentRemoteDataSourceImpl(dio: sl()));
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  final logService = await LogService.instance();
  sl.registerLazySingleton<LogService>(() => logService);

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    final flavor = FlavorService.instance.config;

    dio.options.baseUrl = flavor.baseUrl;
    dio.options.connectTimeout = Duration(seconds: flavor.requestTimeout);
    dio.options.receiveTimeout = Duration(seconds: flavor.requestTimeout);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          sl<LogService>().d('Request: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // sl<LogService>().d('Response: ${response.statusCode} ${response.data}');
          sl<LogService>().d('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          sl<LogService>().e('DioError: ${e.message}', error: e, stackTrace: e.stackTrace);
          return handler.next(e);
        },
      ),
    );

    return dio;
  });
}
