import 'package:flutter_starter_clean_bloc/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:convert';

import '../../../../mocks.dart';

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    dataSource = AuthLocalDataSourceImpl(secureStorage: mockFlutterSecureStorage);
    registerFallbackValue(tAuthModel);
  });

  final String cachedAuth = AuthLocalDataSourceImpl.kCachedAuth;

  group('cacheAuth', () {
    test('should call FlutterSecureStorage to cache the data', () async {
      when(
        () => mockFlutterSecureStorage.write(key: cachedAuth, value: json.encode(tAuthModel)),
      ).thenAnswer((_) async => {});
      await dataSource.cacheAuth(tAuthModel);
      verify(() => mockFlutterSecureStorage.write(key: cachedAuth, value: json.encode(tAuthModel)));
    });
  });

  group('getCachedAuth', () {
    test('should return AuthModel from SharedPreferences when there is one in the cache', () async {
      when(
        () => mockFlutterSecureStorage.read(key: cachedAuth),
      ).thenAnswer((_) async => jsonEncode(tAuthModel.toJson()));
      final result = await dataSource.getCachedAuth();
      verify(() => mockFlutterSecureStorage.read(key: cachedAuth));
      expect(result, equals(tAuthModel));
    });

    test('should return null when there is no cached value', () async {
      when(() => mockFlutterSecureStorage.read(key: cachedAuth)).thenAnswer((_) async => null);
      final result = await dataSource.getCachedAuth();
      verify(() => mockFlutterSecureStorage.read(key: cachedAuth));
      expect(result, isNull);
    });
  });

  group('clearCachedAuth', () {
    test('should call SharedPreferences to remove the cached data', () async {
      when(() => mockFlutterSecureStorage.delete(key: cachedAuth)).thenAnswer((_) async => {});
      await dataSource.clearCachedAuth();
      verify(() => mockFlutterSecureStorage.delete(key: cachedAuth));
    });
  });
}
