import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/usecases/bookmark_post_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late BookmarkPostUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = BookmarkPostUseCase(mockUserRepository);
    registerFallbackValue(tBookmarkPostParams);
  });

  test('should bookmark a post using the repository', () async {
    when(() => mockUserRepository.bookmarkPost(any())).thenAnswer((_) async => const Right(unit));
    final result = await usecase(tBookmarkPostParams);
    expect(result, const Right(unit));
    verify(() => mockUserRepository.bookmarkPost(tBookmarkPostParams));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
