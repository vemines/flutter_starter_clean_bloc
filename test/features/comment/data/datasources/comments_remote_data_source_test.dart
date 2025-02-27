import 'package:dio/dio.dart';
import 'package:flutter_starter_clean_bloc/app/flavor.dart';
import 'package:flutter_starter_clean_bloc/core/constants/api_endpoints.dart';
import 'package:flutter_starter_clean_bloc/core/errors/exceptions.dart';
import 'package:flutter_starter_clean_bloc/features/comment/data/datasources/comment_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late CommentRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    FlavorService.initialize(Flavor.dev);
    mockDio = MockDio();
    dataSource = CommentRemoteDataSourceImpl(dio: mockDio);
  });

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(tCommentModel);
  });

  // TODO: Fix get comments tests
  // group('getCommentsByPostId', () {
  //   test('should perform a GET request and return List<CommentModel>', () async {
  //     when(() => mockDio.get(any())).thenAnswer(
  //       (_) async => Response(
  //         data: [tCommentModel.toJson(), tCommentModel.toJson()],
  //         statusCode: 200,
  //         requestOptions: RequestOptions(
  //           path: ApiEndpoints.getCommentsByPostId(postId: tPostModel.id),
  //         ),
  //       ),
  //     );
  //     final result = await dataSource.getCommentsByPostId(tPostModel.id);
  //     verify(() => mockDio.get(ApiEndpoints.getCommentsByPostId(postId: tPostModel.id)));
  //     expect(result, isA<List<CommentModel>>());
  //     expect(result, equals(tCommentModels));
  //   });

  //   test('should throw a ServerException when the response code is not 200', () async {
  //     when(() => mockDio.get(any())).thenThrow(
  //       DioException(
  //         response: Response(
  //           statusCode: 500,
  //           requestOptions: RequestOptions(
  //             path: ApiEndpoints.getCommentsByPostId(postId: tPostModel.id),
  //           ),
  //         ),
  //         requestOptions: RequestOptions(
  //           path: ApiEndpoints.getCommentsByPostId(postId: tPostModel.id),
  //         ),
  //       ),
  //     );
  //     expect(() => dataSource.getCommentsByPostId(tPostModel.id), throwsA(isA<ServerException>()));
  //   });
  // });

  group('addComment', () {
    test('should perform a POST request with the correct data and return CommentModel', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: tCommentModel.toJson(),
          statusCode: 201,
          requestOptions: RequestOptions(
            path: ApiEndpoints.getCommentsByPostId(postId: tAddCommentParams.postId),
          ),
        ),
      );
      final result = await dataSource.addComment(tAddCommentParams);
      verify(
        () => mockDio.post(
          ApiEndpoints.getCommentsByPostId(postId: tAddCommentParams.postId),
          data: {'userId': tAddCommentParams.userId, 'body': tAddCommentParams.body},
        ),
      );
      expect(result, equals(tCommentModel));
    });

    test('should throw a ServerException when the response code is not 201', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(
              path: ApiEndpoints.getCommentsByPostId(postId: tAddCommentParams.postId),
            ),
          ),
          requestOptions: RequestOptions(
            path: ApiEndpoints.getCommentsByPostId(postId: tAddCommentParams.postId),
          ),
        ),
      );

      expect(() => dataSource.addComment(tAddCommentParams), throwsA(isA<ServerException>()));
    });
  });

  group('updateComment', () {
    test('should perform a PATCH request with correct data and return CommentModel', () async {
      when(() => mockDio.patch(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: tCommentModel.toJson(),
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.singleComment(tCommentModel.id)),
        ),
      );
      final result = await dataSource.updateComment(tCommentModel);
      verify(
        () => mockDio.patch(
          ApiEndpoints.singleComment(tCommentModel.id),
          data: {'userId': tCommentModel.user.id, 'body': tCommentModel.body},
        ),
      );
      expect(result, equals(tCommentModel));
    });

    test('should throw a ServerException when the response code is not 200', () async {
      when(() => mockDio.patch(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(
              path: ApiEndpoints.singleComment(tUpdatedCommentModel.id),
            ),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.singleComment(tUpdatedCommentModel.id)),
        ),
      );
      expect(() => dataSource.updateComment(tUpdatedCommentModel), throwsA(isA<ServerException>()));
    });
  });

  group('deleteComment', () {
    test('should perform a DELETE request with the comment ID and userId', () async {
      when(() => mockDio.delete(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.singleComment(tCommentModel.id)),
        ),
      );
      await dataSource.deleteComment(tCommentModel);
      verify(
        () => mockDio.delete(
          ApiEndpoints.singleComment(tCommentModel.id),
          data: {'userId': tCommentModel.user.id},
        ),
      ); // Verify userId
    });

    test('should throw a ServerException when the response code is not 200', () async {
      when(() => mockDio.delete(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ApiEndpoints.singleComment(tCommentModel.id)),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.singleComment(tCommentModel.id)),
        ),
      );

      expect(() => dataSource.deleteComment(tCommentModel), throwsA(isA<ServerException>()));
    });
  });
}
