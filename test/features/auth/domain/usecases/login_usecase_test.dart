import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
    registerFallbackValue(tLoginParams);
  });

  test('should get auth from the repository', () async {
    when(() => mockAuthRepository.login(any())).thenAnswer((_) async => Right(tAuthEntity));
    final result = await usecase(tLoginParams);
    expect(result, Right(tAuthEntity));
    verify(() => mockAuthRepository.login(tLoginParams));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
