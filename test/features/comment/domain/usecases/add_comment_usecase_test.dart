import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/comment/domain/usecases/add_comment_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late AddCommentUseCase usecase;
  late MockCommentRepository mockCommentRepository;

  setUp(() {
    mockCommentRepository = MockCommentRepository();
    usecase = AddCommentUseCase(mockCommentRepository);
    registerFallbackValue(tAddCommentParams);
  });

  test('should add a comment to the repository', () async {
    when(
      () => mockCommentRepository.addComment(any()),
    ).thenAnswer((_) async => Right(tCommentEntity));
    final result = await usecase(tAddCommentParams);
    expect(result, Right(tCommentEntity));
    verify(() => mockCommentRepository.addComment(tAddCommentParams));
    verifyNoMoreInteractions(mockCommentRepository);
  });
}
