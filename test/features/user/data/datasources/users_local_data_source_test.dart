import 'dart:convert';

import 'package:flutter_starter_clean_bloc/features/user/data/datasources/user_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late UserLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = UserLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  setUpAll(() {
    registerFallbackValue(tUserModel);
  });

  group('cacheUser', () {
    test('should call SharedPreferences to cache the user data', () async {
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);

      await dataSource.cacheUser(tUserModel);

      final expectedJsonString = json.encode(tUserModel.toJson());
      verify(
        () => mockSharedPreferences.setString(
          UserLocalDataSourceImpl.kCachedUsers,
          expectedJsonString,
        ),
      );
    });
  });

  group('getCachedUser', () {
    test('should return UserModel from SharedPreferences when there is one in the cache', () async {
      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn(jsonEncode(tUserModel.toJson()));
      final result = await dataSource.getCachedUser();
      verify(() => mockSharedPreferences.getString(UserLocalDataSourceImpl.kCachedUsers));
      expect(result, equals(tUserModel));
    });

    test('should return null when there is no cached value', () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      final result = await dataSource.getCachedUser();
      verify(() => mockSharedPreferences.getString(UserLocalDataSourceImpl.kCachedUsers));
      expect(result, isNull);
    });

    test('should return null when there is invalid data in the cache', () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn('invalid json');
      final result = await dataSource.getCachedUser();
      verify(() => mockSharedPreferences.getString(UserLocalDataSourceImpl.kCachedUsers));
      expect(result, isNull);
    });
  });
}
