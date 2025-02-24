import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/usecases/get_all_users_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late GetAllUsersUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetAllUsersUseCase(mockUserRepository);
  });
  setUpAll(() {
    registerFallbackValue(tPaginationParams);
  });

  test('should get all users from the repository', () async {
    when(() => mockUserRepository.getAllUsers(any())).thenAnswer((_) async => Right(tUserEntities));

    final result = await usecase(tPaginationParams);

    expect(result, Right(tUserEntities));
    verify(() => mockUserRepository.getAllUsers(tPaginationParams));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
