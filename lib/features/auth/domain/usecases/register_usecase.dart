import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<AuthEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterParams params) async {
    String? validate = _validateParam(params);
    if (validate != null) return Left(InvalidInputFailure(message: validate));

    return await repository.register(params);
  }
}

class RegisterParams extends Equatable {
  final String userName;
  final String password;
  final String email;

  const RegisterParams({required this.userName, required this.password, required this.email});

  @override
  List<Object> get props => [userName, password, email];
}

String? _validateParam(RegisterParams params) {
  if (params.userName.length < 6) return 'Username must be at least 6 characters.';

  if (params.email.isEmpty || !params.email.contains('@')) return 'Invalid email address.';

  if (params.password.length < 6) return 'Password must be at least 6 characters.';

  return null;
}
