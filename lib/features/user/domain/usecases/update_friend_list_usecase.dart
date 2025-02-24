import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/user_repository.dart';

class UpdateFriendListUseCase implements UseCase<Unit, UpdateFriendListParams> {
  final UserRepository repository;

  UpdateFriendListUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateFriendListParams params) async {
    return await repository.updateFriendList(params);
  }
}

class UpdateFriendListParams extends Equatable {
  final int userId;
  final List<int> friendIds;

  const UpdateFriendListParams({required this.userId, required this.friendIds});

  @override
  List<Object?> get props => [userId, friendIds];
}
