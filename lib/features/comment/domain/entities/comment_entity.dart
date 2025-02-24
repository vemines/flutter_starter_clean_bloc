import 'package:equatable/equatable.dart';

import '../../../user/domain/entities/user_entity.dart';

class CommentEntity extends Equatable {
  final int id;
  final int postId;
  final UserEntity user;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.user,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, postId, user, body, createdAt, updatedAt];

  CommentEntity copyWith({
    int? id,
    int? postId,
    UserEntity? user,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      user: user ?? this.user,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
