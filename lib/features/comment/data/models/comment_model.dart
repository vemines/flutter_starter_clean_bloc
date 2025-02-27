import '../../../user/domain/entities/user_entity.dart';

import '../../../../core/constants/api_mapping.dart';
import '../../../user/data/models/user_model.dart';
import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.postId,
    required super.user,
    required super.body,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json[CommentApiMap.kId] as int,
      postId: json[CommentApiMap.kPostId] as int,
      user: UserModel.fromJson(json[CommentApiMap.kUser]),
      body: json[CommentApiMap.kBody] as String,
      createdAt: DateTime.parse(json[CommentApiMap.kCreatedAt] as String),
      updatedAt: DateTime.parse(json[CommentApiMap.kUpdatedAt] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      CommentApiMap.kId: id,
      CommentApiMap.kPostId: postId,
      CommentApiMap.kUser: UserModel.fromEntity(user).toJson(),
      CommentApiMap.kBody: body,
      CommentApiMap.kCreatedAt: createdAt.toIso8601String(),
      CommentApiMap.kUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  factory CommentModel.fromEntity(CommentEntity comment) {
    return CommentModel(
      id: comment.id,
      postId: comment.postId,
      user: UserModel.fromEntity(comment.user),
      body: comment.body,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
    );
  }

  @override
  CommentModel copyWith({
    int? id,
    int? postId,
    UserEntity? user,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      user: user ?? this.user,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
