import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetBookmarkedPostsUseCase implements UseCase<List<PostEntity>, ListIdParams> {
  final PostRepository repository;

  GetBookmarkedPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(ListIdParams params) async {
    return await repository.getBookmarkedPosts(params);
  }
}
