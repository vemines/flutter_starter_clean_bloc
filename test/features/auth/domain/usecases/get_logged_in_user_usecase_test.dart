import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/core/usecase/usecase.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/usecases/get_logged_in_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late GetLoggedInUserUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetLoggedInUserUseCase(mockAuthRepository);
  });

  test('should get logged in user from the repository', () async {
    when(() => mockAuthRepository.getLoggedInUser()).thenAnswer((_) async => Right(tAuthEntity));
    final result = await usecase(NoParams());
    expect(result, Right(tAuthEntity));
    verify(() => mockAuthRepository.getLoggedInUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
