import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/create_post_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late CreatePostUseCase usecase;
  late MockPostRepository mockPostRepository;
  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = CreatePostUseCase(mockPostRepository);
    registerFallbackValue(tPostEntity);
  });
  test('should return created post from the repository', () async {
    when(() => mockPostRepository.createPost(any())).thenAnswer((_) async => Right(tPostEntity));
    final result = await usecase(tPostEntity);
    expect(result, Right(tPostEntity));
    verify(() => mockPostRepository.createPost(tPostEntity));
    verifyNoMoreInteractions(mockPostRepository);
  });
}
