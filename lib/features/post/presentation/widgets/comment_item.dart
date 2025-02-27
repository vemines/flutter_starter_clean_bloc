import 'package:flutter/material.dart';
import 'package:flutter_starter_clean_bloc/core/widgets/widgets.dart';
import 'package:flutter_starter_clean_bloc/features/comment/domain/entities/comment_entity.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.comment,
    required this.isMyComment,
    this.onEdit,
    this.onDelete,
  });

  final CommentEntity comment;
  final bool isMyComment;
  final Function()? onEdit;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(radius: 30, child: CachedImage(imageUrl: comment.user.avatar)),
      title: Text(comment.user.userName),
      subtitle: Text(comment.body),
      trailing:
          isMyComment
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () => onEdit),
                  IconButton(icon: const Icon(Icons.delete), onPressed: () => onDelete),
                ],
              )
              : SizedBox.shrink(),
    );
  }
}
