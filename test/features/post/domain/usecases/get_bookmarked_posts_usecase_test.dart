import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/get_bookmarked_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late GetBookmarkedPostsUseCase usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetBookmarkedPostsUseCase(mockPostRepository);
    registerFallbackValue(tListBookmarkPostIdParams);
  });
  test('should get bookmarked posts from the repository', () async {
    when(
      () => mockPostRepository.getBookmarkedPosts(any()),
    ).thenAnswer((_) async => Right(tPostEntities));
    final result = await usecase(tListBookmarkPostIdParams);
    expect(result, Right(tPostEntities));
    verify(() => mockPostRepository.getBookmarkedPosts(tListBookmarkPostIdParams));
    verifyNoMoreInteractions(mockPostRepository);
  });
}
