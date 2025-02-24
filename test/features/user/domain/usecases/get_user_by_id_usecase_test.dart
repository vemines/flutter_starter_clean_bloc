import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late GetUserByIdUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserByIdUseCase(mockUserRepository);
  });
  setUpAll(() {
    registerFallbackValue(tUserIdParams);
  });

  test('should get user by ID from the repository', () async {
    when(() => mockUserRepository.getUserById(any())).thenAnswer((_) async => Right(tUserEntity));

    final result = await usecase(tUserIdParams);

    expect(result, Right(tUserEntity));
    verify(() => mockUserRepository.getUserById(tUserIdParams));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
