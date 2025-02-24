import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/search_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late SearchPostsUseCase usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = SearchPostsUseCase(mockPostRepository);
    registerFallbackValue(tPaginationWithSearchParams);
  });

  test('should search posts from the repository', () async {
    when(() => mockPostRepository.searchPosts(any())).thenAnswer((_) async => Right(tPostEntities));
    final result = await usecase(tPaginationWithSearchParams);
    expect(result, Right(tPostEntities));
    verify(() => mockPostRepository.searchPosts(tPaginationWithSearchParams));
    verifyNoMoreInteractions(mockPostRepository);
  });
}
