import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetAllPostsUseCase implements UseCase<List<PostEntity>, PaginationParams> {
  final PostRepository repository;

  GetAllPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(PaginationParams params) async {
    return await repository.getAllPosts(params);
  }
}
