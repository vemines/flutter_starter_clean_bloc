import 'dart:convert';

import 'package:flutter_starter_clean_bloc/core/errors/exceptions.dart';
import 'package:flutter_starter_clean_bloc/features/post/data/datasources/post_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late PostLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = PostLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getCachedPosts', () {
    test('should return List<PostModel> from SharedPreferences when available', () async {
      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn(jsonEncode([tPostModel.toJson(), tPostModel.toJson()]));
      final result = await dataSource.getCachedPosts();
      verify(() => mockSharedPreferences.getString(kCachedPost));
      expect(result, equals(tPostModels));
    });

    test('should throw CacheException when there is no cached value', () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      expect(() => dataSource.getCachedPosts(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cachePosts', () {
    test('should call SharedPreferences to cache the data', () async {
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
      await dataSource.cachePosts(tPostModels);
      verify(() => mockSharedPreferences.setString(kCachedPost, any()));
    });
  });
}
