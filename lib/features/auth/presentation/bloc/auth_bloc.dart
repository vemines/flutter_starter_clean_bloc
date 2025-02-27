import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/logs.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/params.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/get_logged_in_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/verify_secret_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetLoggedInUserUseCase getLoggedInUserUseCase;
  final LogoutUseCase logoutUseCase;
  final VerifySecretUseCase verifySecretUseCase;
  final LogService logService;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getLoggedInUserUseCase,
    required this.logoutUseCase,
    required this.verifySecretUseCase,
    required this.logService,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<GetLoggedInUserEvent>(_onGetLoggedInUser);
    on<LogoutEvent>(_onLogout);
    on<VerifySecretEvent>(_onVerifySecret);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.params);
    emit(_mapResultToAuthLoaded(result, '_onLogin(LoginEvent event, Emitter<AuthState> emit)'));
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(event.params);
    emit(
      _mapResultToAuthLoaded(result, '_onRegister(RegisterEvent event, Emitter<AuthState> emit)'),
    );
  }

  Future<void> _onGetLoggedInUser(GetLoggedInUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getLoggedInUserUseCase(NoParams());
    emit(
      _mapResultToAuthLoaded(
        result,
        '_onGetLoggedInUser(GetLoggedInUserEvent event, Emitter<AuthState> emit)',
      ),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold((failure) {
      logService.w('$failure occur at _onLogout(LogoutEvent event, Emitter<AuthState> emit)');
      emit(AuthError(failure: failure));
    }, (_) => emit(AuthInitial()));
  }

  Future<void> _onVerifySecret(VerifySecretEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final cachedAuthResult = await getLoggedInUserUseCase(NoParams());

    await cachedAuthResult.fold(
      (failure) {
        logService.w(
          '$failure occur at _onVerifySecret(VerifySecretEvent event, Emitter<AuthState> emit)',
        );
        emit(AuthError(failure: failure));
      },
      (auth) async {
        await _verifySecret(auth, emit);
      },
    );
  }

  Future<void> _verifySecret(AuthEntity auth, Emitter<AuthState> emit) async {
    final result = await verifySecretUseCase(auth);
    emit(
      result.fold(
        (failure) {
          logService.w('$failure occur at _verifySecret(AuthEntity auth, Emitter<AuthState> emit)');
          return AuthError(failure: failure);
        },
        (isVerified) {
          if (isVerified) return AuthVerified();
          return AuthError(failure: UnauthenticatedFailure());
        },
      ),
    );
  }

  AuthState _mapResultToAuthLoaded(Either<Failure, AuthEntity> result, String errorAt) {
    return result.fold(
      (failure) {
        if (errorAt.contains('GetLoggedInUserEvent')) {
          return AuthInitial();
        }
        logService.w('$failure occur at $errorAt');
        return AuthError(failure: failure);
      },
      (auth) {
        return AuthLoaded(auth: auth);
      },
    );
  }
}
