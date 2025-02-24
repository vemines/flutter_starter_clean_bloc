import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../usecases/bookmark_post_usecase.dart';
import '../usecases/update_friend_list_usecase.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getAllUsers(PaginationParams params);
  Future<Either<Failure, UserEntity>> getUserById(IdParams params);
  Future<Either<Failure, UserEntity>> updateUser(UserEntity userEntity);
  Future<Either<Failure, Unit>> updateFriendList(UpdateFriendListParams params);
  Future<Either<Failure, Unit>> bookmarkPost(BookmarkPostParams params);
}
