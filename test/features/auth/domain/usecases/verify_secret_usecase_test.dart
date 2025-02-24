import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/auth/domain/usecases/verify_secret_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late VerifySecretUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = VerifySecretUseCase(mockAuthRepository);
    registerFallbackValue(tAuthEntity);
  });
  test('should verify secret from the repository', () async {
    when(() => mockAuthRepository.verifySecret(any())).thenAnswer((_) async => const Right(true));
    final result = await usecase(tAuthEntity);
    expect(result, const Right(true));
    verify(() => mockAuthRepository.verifySecret(tAuthEntity));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
