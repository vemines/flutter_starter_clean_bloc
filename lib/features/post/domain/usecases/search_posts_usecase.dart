import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class SearchPostsUseCase implements UseCase<List<PostEntity>, PaginationWithSearchParams> {
  final PostRepository repository;

  SearchPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(PaginationWithSearchParams params) async {
    return await repository.searchPosts(params);
  }
}
