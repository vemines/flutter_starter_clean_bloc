import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_starter_clean_bloc/core/errors/failures.dart';
import 'package:flutter_starter_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late AuthBloc bloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockGetLoggedInUserUseCase mockGetLoggedInUserUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockVerifySecretUseCase mockVerifySecretUseCase;
  late MockLogService mockLogService;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockGetLoggedInUserUseCase = MockGetLoggedInUserUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockVerifySecretUseCase = MockVerifySecretUseCase();
    mockLogService = MockLogService();

    bloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      getLoggedInUserUseCase: mockGetLoggedInUserUseCase,
      logoutUseCase: mockLogoutUseCase,
      verifySecretUseCase: mockVerifySecretUseCase,
      logService: mockLogService,
    );
    registerFallbackValue(tSecret);
    registerFallbackValue(tNoParams);
    registerFallbackValue(tLoginParams);
    registerFallbackValue(tRegisterParams);
    registerFallbackValue(tAuthEntity);
  });

  tearDown(() {
    bloc.close();
  });

  test('initialState should be AuthInitial', () {
    expect(bloc.state, equals(AuthInitial()));
  });

  group('LoginEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthLoaded] when login is successful',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer((_) async => Right(tAuthEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(LoginEvent(params: tLoginParams)),
      expect: () => [AuthLoading(), AuthLoaded(auth: tAuthEntity)],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(LoginEvent(params: tLoginParams)),
      expect: () => [AuthLoading(), AuthError(failure: tServerFailure)],
    );
  });

  group('RegisterEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthLoaded] when register is successful',
      build: () {
        when(() => mockRegisterUseCase(any())).thenAnswer((_) async => Right(tAuthEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(RegisterEvent(params: tRegisterParams)),
      expect: () => [AuthLoading(), AuthLoaded(auth: tAuthEntity)],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when register fails',
      build: () {
        when(() => mockRegisterUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(RegisterEvent(params: tRegisterParams)),
      expect: () => [AuthLoading(), AuthError(failure: tServerFailure)],
    );
  });

  group('GetLoggedInUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthLoaded] when get logged in user is successful',
      build: () {
        when(() => mockGetLoggedInUserUseCase(any())).thenAnswer((_) async => Right(tAuthEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(GetLoggedInUserEvent()),
      expect: () => [AuthLoading(), AuthLoaded(auth: tAuthEntity)],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when get logged in user fails',
      build: () {
        when(() => mockGetLoggedInUserUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetLoggedInUserEvent()),
      expect: () => [AuthLoading(), AuthError(failure: tServerFailure)],
    );
  });

  group('LogoutEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthInitial] when logout is successful',
      build: () {
        when(() => mockLogoutUseCase(any())).thenAnswer((_) async => Right(unit));
        return bloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [AuthLoading(), AuthInitial()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when logout fails',
      build: () {
        when(() => mockLogoutUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [AuthLoading(), AuthError(failure: tServerFailure)],
    );
  });

  group('VerifySecretEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthVerified] when secret is verified',
      build: () {
        when(() => mockGetLoggedInUserUseCase(any())).thenAnswer((_) async => Right(tAuthEntity));
        when(() => mockVerifySecretUseCase(any())).thenAnswer((_) async => Right(true));
        return bloc;
      },
      act: (bloc) => bloc.add(VerifySecretEvent()),
      expect: () => [AuthLoading(), AuthVerified()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when secret verification fails',
      build: () {
        when(() => mockGetLoggedInUserUseCase(any())).thenAnswer((_) async => Right(tAuthEntity));
        when(() => mockVerifySecretUseCase(any())).thenAnswer((_) async => Left(tServerFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(VerifySecretEvent()),
      expect: () => [AuthLoading(), AuthError(failure: tServerFailure)],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] with custom message when secret verification returns false',
      build: () {
        when(() => mockGetLoggedInUserUseCase(any())).thenAnswer((_) async => Right(tAuthEntity));
        when(() => mockVerifySecretUseCase(any())).thenAnswer((_) async => const Right(false));
        return bloc;
      },
      act: (bloc) => bloc.add(VerifySecretEvent()),
      expect: () => [AuthLoading(), AuthError(failure: UnauthenticatedFailure())],
    );
  });
}
