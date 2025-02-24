import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/features/user/domain/usecases/update_friend_list_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late UpdateFriendListUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UpdateFriendListUseCase(mockUserRepository);
  });

  setUpAll(() {
    registerFallbackValue(tUpdateFriendListParams);
  });

  test('should update user friend list from the repository', () async {
    when(
      () => mockUserRepository.updateFriendList(any()),
    ).thenAnswer((_) async => const Right(unit));

    final result = await usecase(tUpdateFriendListParams);

    expect(result, const Right(unit));
    verify(() => mockUserRepository.updateFriendList(tUpdateFriendListParams));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
