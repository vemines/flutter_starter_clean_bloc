import '../../../../core/constants/api_mapping.dart';
import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    required super.imageUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json[PostApiMap.kId] as int,
      userId: json[PostApiMap.kUserId] as int,
      title: json[PostApiMap.kTitle] as String,
      body: json[PostApiMap.kBody] as String,
      imageUrl: json[PostApiMap.kImageUrl] as String,
      createdAt: DateTime.parse(json[PostApiMap.kcreatedAt] as String),
      updatedAt: DateTime.parse(json[PostApiMap.kUpdatedAt] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PostApiMap.kId: id,
      PostApiMap.kUserId: userId,
      PostApiMap.kTitle: title,
      PostApiMap.kBody: body,
      PostApiMap.kImageUrl: imageUrl,
      PostApiMap.kcreatedAt: createdAt.toIso8601String(),
      PostApiMap.kUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  factory PostModel.fromEntity(PostEntity post) {
    return PostModel(
      id: post.id,
      userId: post.userId,
      title: post.title,
      body: post.body,
      imageUrl: post.imageUrl,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
    );
  }

  @override
  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
