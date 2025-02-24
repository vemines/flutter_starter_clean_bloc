part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final AuthEntity auth;

  const AuthLoaded({required this.auth});

  @override
  List<Object> get props => [auth];
}

class AuthError extends AuthState {
  final Failure failure;

  const AuthError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AuthVerified extends AuthState {}
