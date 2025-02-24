import 'package:dio/dio.dart';
import 'package:flutter_starter_clean_bloc/app/flavor.dart';
import 'package:flutter_starter_clean_bloc/core/constants/api_endpoints.dart';
import 'package:flutter_starter_clean_bloc/core/constants/enum.dart';
import 'package:flutter_starter_clean_bloc/core/errors/exceptions.dart';
import 'package:flutter_starter_clean_bloc/features/post/data/datasources/post_remote_data_source.dart';
import 'package:flutter_starter_clean_bloc/features/post/data/models/post_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late PostRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    FlavorService.initialize(Flavor.dev);
    mockDio = MockDio();
    dataSource = PostRemoteDataSourceImpl(dio: mockDio);
  });

  setUpAll(() {
    registerFallbackValue(tPostModel);
  });

  final jsonListPost = [tPostModel.toJson(), tPostModel.toJson()];

  group('getAllPosts', () {
    test('should perform a GET request with pagination parameters', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          data: [tPostModel.toJson()],
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      await dataSource.getAllPosts(tPaginationParams);
      verify(
        () => mockDio.get(
          ApiEndpoints.posts,
          queryParameters: {
            '_page': tPaginationParams.page,
            '_limit': tPaginationParams.limit,
            '_sort': 'createdAt',
            '_order': tPaginationParams.order.getString(),
          },
        ),
      );
    });

    test('should return List<PostModel> when the response code is 200', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          data: jsonListPost,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      final result = await dataSource.getAllPosts(tPaginationParams);
      expect(result, isA<List<PostModel>>());
      expect(result, equals(tPostModels));
    });

    test('should throw a ServerException when the response code is not 200', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ApiEndpoints.posts),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      expect(() => dataSource.getAllPosts(tPaginationParams), throwsA(isA<ServerException>()));
    });
  });

  group('getPostById', () {
    test('should perform a GET request on a URL with the post ID', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: tPostModel.toJson(),
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
        ),
      );
      await dataSource.getPostById(tPostIdParams.id);
      verify(() => mockDio.get(ApiEndpoints.singlePost(tPostModel.id)));
    });

    test('should return PostModel when the response code is 200', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: tPostModel.toJson(),
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
        ),
      );
      final result = await dataSource.getPostById(tPostModel.id);
      expect(result, isA<PostModel>());
      expect(result, equals(tPostModel));
    });

    test('should throw a ServerException when the response code is not 200', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
        ),
      );
      expect(() => dataSource.getPostById(tPostModel.id), throwsA(isA<ServerException>()));
    });
  });

  group('createPost', () {
    test('should perform a POST request with the post data', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: tPostModel.toJson(),
          statusCode: 201,
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      await dataSource.createPost(tPostModel);
      verify(() => mockDio.post(ApiEndpoints.posts, data: tPostModel.toJson()));
    });

    test('should return PostModel when the response code is 201 or 200', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: tPostModel.toJson(),
          statusCode: 201,
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      final result = await dataSource.createPost(tPostModel);
      expect(result, isA<PostModel>());
      expect(result, equals(tPostModel));
    });

    test('should throw a ServerException when the response code is not 2xx', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ApiEndpoints.posts),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      expect(() => dataSource.createPost(tPostModel), throwsA(isA<ServerException>()));
    });
  });

  group('updatePost', () {
    test('should perform a PUT request with the post data', () async {
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: tPostModel.toJson(),
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
        ),
      );

      await dataSource.updatePost(tPostModel);
      verify(() => mockDio.put(ApiEndpoints.singlePost(tPostModel.id), data: tPostModel.toJson()));
    });

    test('should return PostModel when the response code is 200', () async {
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: tPostModel.toJson(),
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
        ),
      );
      final result = await dataSource.updatePost(tPostModel);
      expect(result, isA<PostModel>());
      expect(result, equals(tPostModel));
    });

    test('should throw a ServerException when the response code is not 200', () async {
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
        ),
      );
      expect(() => dataSource.updatePost(tPostModel), throwsA(isA<ServerException>()));
    });
  });

  group('deletePost', () {
    test('should perform a DELETE request with the post ID', () async {
      when(() => mockDio.delete(any())).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
        ),
      );
      await dataSource.deletePost(tPostModel.id);
      verify(() => mockDio.delete(ApiEndpoints.singlePost(tPostModel.id)));
    });

    test('should complete successfully when the response code is 200 or 204', () async {
      when(() => mockDio.delete(any())).thenAnswer(
        (_) async => Response(
          statusCode: 204,
          requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
        ),
      );
      await dataSource.deletePost(tPostModel.id);
    });

    test('should throw a ServerException when the response code is not 200 or 204', () async {
      when(() => mockDio.delete(any())).thenThrow(
        DioException(
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id)),
        ),
      );
      expect(() => dataSource.deletePost(tPostModel.id), throwsA(isA<ServerException>()));
    });

    test('should throw a ServerException when dio error', () async {
      when(() => mockDio.delete(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: ApiEndpoints.singlePost(tPostModel.id))),
      );
      expect(() => dataSource.deletePost(tPostModel.id), throwsA(isA<ServerException>()));
    });
  });

  group('searchPosts', () {
    test('should perform a GET request with search query and pagination', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          data: [tPostModel.toJson()],
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      await dataSource.searchPosts(tPaginationWithSearchParams);
      verify(
        () => mockDio.get(
          ApiEndpoints.posts,
          queryParameters: {
            'q': tPaginationWithSearchParams.search,
            '_page': tPaginationWithSearchParams.page,
            '_limit': tPaginationWithSearchParams.limit,
            '_sort': 'createdAt',
            '_order': tPaginationWithSearchParams.order.getString(),
          },
        ),
      );
    });

    test('should return List<PostModel> when response code is 200', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          data: jsonListPost,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      final result = await dataSource.searchPosts(tPaginationWithSearchParams);
      expect(result, isA<List<PostModel>>());
      expect(result, equals(tPostModels));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ApiEndpoints.posts),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      expect(
        () => dataSource.searchPosts(tPaginationWithSearchParams),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getPostsByIds', () {
    test('should perform a GET request with a list of post IDs', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          data: jsonListPost,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      await dataSource.getPostsByIds(tListBookmarkPostIdParams);
      verify(
        () =>
            mockDio.get(ApiEndpoints.posts, queryParameters: {'id': tListBookmarkPostIdParams.ids}),
      );
    });

    test('should return List<PostModel> when response code is 200', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          data: jsonListPost,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      final result = await dataSource.getPostsByIds(tListBookmarkPostIdParams);
      expect(result, isA<List<PostModel>>());
      expect(result, equals(tPostModels));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ApiEndpoints.posts),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.posts),
        ),
      );
      expect(
        () => dataSource.getPostsByIds(tListBookmarkPostIdParams),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
