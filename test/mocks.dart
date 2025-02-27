import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_starter_clean_bloc/app/logs.dart';
import 'package:flutter_starter_clean_bloc/core/errors/exceptions.dart';
import 'package:flutter_starter_clean_bloc/core/errors/failures.dart';
import 'package:flutter_starter_clean_bloc/core/network/network_info.dart';
import 'package:flutter_starter_clean_bloc/core/usecase/params.dart';
import 'package:flutter_starter_clean_bloc/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_starter_clean_bloc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_starter_clean_bloc/features/auth/data/models/auth_model.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/usecases/get_logged_in_user_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/usecases/verify_secret_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/comment/data/datasources/comment_remote_data_source.dart';
import 'package:flutter_starter_clean_bloc/features/comment/data/models/comment_model.dart';
import 'package:flutter_starter_clean_bloc/features/comment/domain/entities/comment_entity.dart';
import 'package:flutter_starter_clean_bloc/features/comment/domain/repositories/comment_repository.dart';
import 'package:flutter_starter_clean_bloc/features/comment/domain/usecases/add_comment_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/comment/domain/usecases/delete_comment_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/comment/domain/usecases/get_comments_by_post_id_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/comment/domain/usecases/update_comment_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/post/data/datasources/post_local_data_source.dart';
import 'package:flutter_starter_clean_bloc/features/post/data/datasources/post_remote_data_source.dart';
import 'package:flutter_starter_clean_bloc/features/post/data/models/post_model.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/entities/post_entity.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/repositories/post_repository.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/create_post_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/delete_post_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/get_all_posts_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/get_bookmarked_posts_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/get_post_by_id_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/search_posts_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/update_post_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/user/data/datasources/user_local_data_source.dart';
import 'package:flutter_starter_clean_bloc/features/user/data/datasources/user_remote_data_source.dart';
import 'package:flutter_starter_clean_bloc/features/user/data/models/user_model.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/entities/user_entity.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/repositories/user_repository.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/usecases/bookmark_post_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/usecases/get_all_users_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/usecases/update_friend_list_usecase.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/usecases/update_user_usecase.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock Classes
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockGetLoggedInUserUseCase extends Mock implements GetLoggedInUserUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockVerifySecretUseCase extends Mock implements VerifySecretUseCase {}

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

class MockPostRepository extends Mock implements PostRepository {}

class MockGetAllPostsUseCase extends Mock implements GetAllPostsUseCase {}

class MockGetPostByIdUseCase extends Mock implements GetPostByIdUseCase {}

class MockCreatePostUseCase extends Mock implements CreatePostUseCase {}

class MockUpdatePostUseCase extends Mock implements UpdatePostUseCase {}

class MockDeletePostUseCase extends Mock implements DeletePostUseCase {}

class MockSearchPostsUseCase extends Mock implements SearchPostsUseCase {}

class MockGetBookmarkedPostsUseCase extends Mock implements GetBookmarkedPostsUseCase {}

class MockBookmarkPostUseCase extends Mock implements BookmarkPostUseCase {}

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class MockUserRepository extends Mock implements UserRepository {}

class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}

class MockGetUserByIdUseCase extends Mock implements GetUserByIdUseCase {}

class MockUpdateUserUseCase extends Mock implements UpdateUserUseCase {}

class MockUpdateFriendListUseCase extends Mock implements UpdateFriendListUseCase {}

class MockCommentRemoteDataSource extends Mock implements CommentRemoteDataSource {}

class MockCommentRepository extends Mock implements CommentRepository {}

class MockGetCommentsByPostIdUseCase extends Mock implements GetCommentsByPostIdUseCase {}

class MockAddCommentUseCase extends Mock implements AddCommentUseCase {}

class MockUpdateCommentUseCase extends Mock implements UpdateCommentUseCase {}

class MockDeleteCommentUseCase extends Mock implements DeleteCommentUseCase {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockDio extends Mock implements Dio {}

class MockInternetConnection extends Mock implements InternetConnection {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockLogService extends Mock implements LogService {}

// Mock Variables

final datetime = DateTime.now();

// Auth
final tAuthEntity = AuthEntity(
  id: 1,
  fullName: 'Test User',
  userName: 'testuser',
  email: 'test@example.com',
  secret: tSecret,
);
final tAuthModel = AuthModel.fromEntity(tAuthEntity);
final tSecret = 'test_secret';
final tRegisterParams = RegisterParams(
  userName: 'testuser',
  password: 'password',
  email: 'test@example.com',
);
final tLoginParams = LoginParams(
  username: tRegisterParams.userName,
  password: tRegisterParams.password,
);

// Post
final tPostEntity = PostEntity(
  id: 1,
  userId: tUserEntity.id,
  title: "Test",
  body: "body",
  imageUrl: "imageUrl",
  createdAt: datetime,
  updatedAt: datetime,
);
final tPostEntityUpdate = tPostEntity.copyWith(body: 'updated Body');
final tPostModel = PostModel.fromEntity(tPostEntity);
final tPostModels = [tPostModel, tPostModel];
final tPostEntities = [tPostEntity, tPostEntity];
final tPostIdParams = IdParams(id: tPostEntity.id);
final tPaginationParams = PaginationParams(page: 1, limit: 10);
final tQuery = 'test';
final tPaginationWithSearchParams = PaginationWithSearchParams(page: 1, limit: 10, search: tQuery);

// User
final tUserEntity = UserEntity(
  id: 1,
  fullName: 'Test User',
  userName: 'testuser',
  email: 'test@example.com',
  avatar: 'avatar_url',
  cover: 'cover_url',
  about: 'about_me',
  bookmarksId: tBookmarkedIds,
  friendsId: tFriendIds,
);
final tUserModel = UserModel.fromEntity(tUserEntity);
final tUpdateUserModel = tUserModel.copyWith(fullName: 'Updated Name');
final tUpdateUserEntity = tUserEntity.copyWith(fullName: 'Updated Name');
final tUserModels = [tUserModel, tUserModel];
final tUserEntities = [tUserEntity, tUserEntity];
final tFriendIds = [2, 3];
final tBookmarkedIds = [1, 2, 3];
final tUserIdParams = IdParams(id: tUserEntity.id);
final tListBookmarkPostIdParams = ListIdParams(ids: tUserEntity.bookmarksId);
final tBookmarkPostParams = BookmarkPostParams(
  postId: tPostEntity.id,
  bookmarkedPostIds: tUserEntity.bookmarksId,
  userId: tUserEntity.id,
);
final tUpdateFriendListParams = UpdateFriendListParams(
  userId: tUserEntity.id,
  friendIds: tFriendIds,
);

// Comment
final tCommentEntity = CommentEntity(
  id: 1,
  postId: tPostEntity.id,
  user: tUserEntity,
  body: 'Test comment',
  createdAt: datetime,
  updatedAt: datetime,
);
final tUpdatedCommentEntity = tCommentEntity.copyWith(body: 'Updated comment');
final tCommentModel = CommentModel.fromEntity(tCommentEntity);
final tUpdatedCommentModel = tCommentModel.copyWith(body: 'Updated comment');
final tCommentModels = [tCommentModel, tCommentModel];
final tCommentEntities = [tCommentModel, tCommentModel];
final tAddCommentParams = AddCommentParams(
  postId: tPostEntity.id,
  userId: tUserEntity.id,
  body: 'Test Body',
);
//
final tGetCommentsParams = GetCommentsParams(postId: tPostEntity.id, page: 1, limit: 10);

final tServerException = ServerException(message: 'ServerException', statusCode: -1);
final tServerFailure = tServerException.toFailure();
final tNoInternetFailure = NoInternetFailure();

final tNoParams = NoParams();

void registerFallbackValues() {
  // Auth
  registerFallbackValue(tLoginParams);
  registerFallbackValue(tRegisterParams);
  registerFallbackValue(tAuthModel);
  registerFallbackValue(tAuthEntity);
  registerFallbackValue(tNoParams);

  // Post
  registerFallbackValue(tPostModel);
  registerFallbackValue(tPostEntity);
  registerFallbackValue(tPaginationParams);
  registerFallbackValue(tPaginationWithSearchParams);
  registerFallbackValue(tListBookmarkPostIdParams);
  registerFallbackValue(IdParams(id: 1));

  // User
  registerFallbackValue(tUserModel);
  registerFallbackValue(tUserIdParams);
  registerFallbackValue(tUpdateFriendListParams);
  registerFallbackValue(tBookmarkPostParams);

  // Comment
  registerFallbackValue(tAddCommentParams);
  registerFallbackValue(tGetCommentsParams);
  registerFallbackValue(tCommentModel);
  registerFallbackValue(tCommentEntity);

  // Core
  registerFallbackValue(Uri());
  registerFallbackValue(<String, dynamic>{});
}
