import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/post/domain/usecases/delete_post_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late DeletePostUseCase usecase;
  late MockPostRepository mockPostRepository;
  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = DeletePostUseCase(mockPostRepository);
    registerFallbackValue(tPostEntity);
  });
  test('should delete post from the repository', () async {
    when(() => mockPostRepository.deletePost(any())).thenAnswer((_) async => const Right(unit));
    final result = await usecase(tPostEntity);
    expect(result, const Right(unit));
    verify(() => mockPostRepository.deletePost(tPostEntity));
    verifyNoMoreInteractions(mockPostRepository);
  });
}
