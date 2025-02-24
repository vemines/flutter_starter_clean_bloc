import 'package:dio/dio.dart';
import 'package:flutter_starter_clean_bloc/app/flavor.dart';
import 'package:flutter_starter_clean_bloc/core/constants/api_endpoints.dart';
import 'package:flutter_starter_clean_bloc/core/errors/exceptions.dart';
import 'package:flutter_starter_clean_bloc/features/user/data/datasources/user_remote_data_source.dart';
import 'package:flutter_starter_clean_bloc/features/user/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late UserRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    FlavorService.initialize(Flavor.dev);
    mockDio = MockDio();
    dataSource = UserRemoteDataSourceImpl(dio: mockDio);
  });

  group('getAllUsers', () {
    test(
      'should perform a GET request with correct parameters and return List<UserModel>',
      () async {
        when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
          (_) async => Response(
            data: [tUserModel.toJson(), tUserModel.toJson()],
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.users),
          ),
        );

        final result = await dataSource.getAllUsers(tPaginationParams);

        verify(
          () => mockDio.get(
            ApiEndpoints.users,
            queryParameters: {
              '_page': tPaginationParams.page,
              '_limit': tPaginationParams.limit,
              '_order': 'desc',
            },
          ),
        );
        expect(result, isA<List<UserModel>>());
        expect(result, equals(tUserModels));
      },
    );

    test('should throw ServerException when response code is not 200', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ApiEndpoints.users),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.users),
        ),
      );

      final call = dataSource.getAllUsers;
      expect(() => call(tPaginationParams), throwsA(isA<ServerException>()));
    });
  });

  group('getUserById', () {
    test('should perform a GET request and return UserModel', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: tUserModel.toJson(), // Return direct object
          statusCode: 200,
          requestOptions: RequestOptions(path: '${ApiEndpoints.users}/1'),
        ),
      );

      final result = await dataSource.getUserById(tUserModel.id);

      verify(() => mockDio.get(ApiEndpoints.singleUser(tUserModel.id)));
      expect(result, isA<UserModel>());
      expect(result, equals(tUserModel));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '${ApiEndpoints.users}/1'),
          ),
          requestOptions: RequestOptions(path: '${ApiEndpoints.users}/1'),
        ),
      );

      final call = dataSource.getUserById;
      expect(() => call(tUserModel.id), throwsA(isA<ServerException>()));
    });
  });

  group('updateUser', () {
    test('should perform a PUT request and return UserModel', () async {
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: tUserModel.toJson(),
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.singleUser(tUserModel.id)),
        ),
      );

      final result = await dataSource.updateUser(tUserModel);

      verify(() => mockDio.put(ApiEndpoints.singleUser(tUserModel.id), data: tUserModel.toJson()));
      expect(result, isA<UserModel>());
      expect(result, equals(tUserModel));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: ApiEndpoints.singleUser(tUserModel.id)),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.singleUser(tUserModel.id)),
        ),
      );

      final call = dataSource.updateUser;
      expect(() => call(tUserModel), throwsA(isA<ServerException>()));
    });
  });

  group('updateFriendList', () {
    test('should perform a PATCH request with correct data', () async {
      when(() => mockDio.patch(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.userFriends(1)),
        ),
      );

      await dataSource.updateFriendList(tUpdateFriendListParams);

      verify(
        () => mockDio.patch(
          ApiEndpoints.userFriends(tUpdateFriendListParams.userId),
          data: {'friendIds': tUpdateFriendListParams.friendIds},
        ),
      );
    });

    test('should throw ServerException for non-200 status codes', () async {
      when(() => mockDio.patch(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: ApiEndpoints.userFriends(1)),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.userFriends(1)),
        ),
      );

      expect(
        () => dataSource.updateFriendList(tUpdateFriendListParams),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('bookmarkPost', () {
    test('should perform a PATCH request to bookmark a post', () async {
      when(() => mockDio.patch(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: ApiEndpoints.bookmarkPost(userId: tBookmarkPostParams.userId),
          ),
        ),
      );
      await dataSource.bookmarkPost(tBookmarkPostParams);
      verify(
        () => mockDio.patch(
          ApiEndpoints.bookmarkPost(userId: tBookmarkPostParams.userId),
          data: {'postId': tBookmarkPostParams.postId},
        ),
      );
    });

    test('should throw ServerException for non-200 status codes', () async {
      when(() => mockDio.patch(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(
              path: ApiEndpoints.bookmarkPost(userId: tBookmarkPostParams.userId),
            ),
          ),
          requestOptions: RequestOptions(
            path: ApiEndpoints.bookmarkPost(userId: tBookmarkPostParams.userId),
          ),
        ),
      );
      expect(() => dataSource.bookmarkPost(tBookmarkPostParams), throwsA(isA<ServerException>()));
    });
  });
}
