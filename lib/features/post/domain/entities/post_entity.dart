import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, title, body, imageUrl, createdAt, updatedAt];

  PostEntity copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostEntity(
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
