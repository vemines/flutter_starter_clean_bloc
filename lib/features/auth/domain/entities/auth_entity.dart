import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final int id;
  final String fullName;
  final String userName;
  final String email;
  final String secret;

  const AuthEntity({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.secret,
  });

  @override
  List<Object> get props => [id, fullName, userName, email, secret];
}
