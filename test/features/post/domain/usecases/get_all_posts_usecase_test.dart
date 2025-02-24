import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/get_all_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late GetAllPostsUseCase usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetAllPostsUseCase(mockPostRepository);
    registerFallbackValue(tPaginationParams);
  });

  test('should get all posts from the repository', () async {
    when(() => mockPostRepository.getAllPosts(any())).thenAnswer((_) async => Right(tPostEntities));
    final result = await usecase(tPaginationParams);
    expect(result, Right(tPostEntities));
    verify(() => mockPostRepository.getAllPosts(tPaginationParams));
    verifyNoMoreInteractions(mockPostRepository);
  });
}
