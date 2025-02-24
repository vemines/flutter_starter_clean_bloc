import '../../../../core/constants/api_mapping.dart';
import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.id,
    required super.fullName,
    required super.userName,
    required super.email,
    required super.secret,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json[UserApiMap.kId],
      fullName: json[UserApiMap.kFullName],
      userName: json[UserApiMap.kUserName],
      email: json[UserApiMap.kEmail],
      secret: json[UserApiMap.kSecret],
    );
  }

  factory AuthModel.fromEntity(AuthEntity auth) {
    return AuthModel(
      id: auth.id,
      fullName: auth.fullName,
      userName: auth.userName,
      email: auth.email,
      secret: auth.secret,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      UserApiMap.kId: id,
      UserApiMap.kFullName: fullName,
      UserApiMap.kUserName: userName,
      UserApiMap.kEmail: email,
      UserApiMap.kSecret: secret,
    };
  }

  AuthModel copyWith({int? id, String? fullName, String? userName, String? email, String? secret}) {
    return AuthModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      secret: secret ?? this.secret,
    );
  }
}
