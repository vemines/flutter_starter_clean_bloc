import 'package:flutter/material.dart';
import 'package:flutter_starter_clean_bloc/core/extensions/widget_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/widgets/post_item.dart';
import '../../domain/entities/post_entity.dart';

class ListPostWidget extends StatelessWidget {
  const ListPostWidget(this.posts, this.hasMore, {super.key});

  final List<PostEntity> posts;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, _) => 16.sbH(),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: hasMore ? posts.length + 1 : posts.length,
      itemBuilder: (context, index) {
        if (index < posts.length) {
          final post = posts[index];
          return PostItem(
            key: post.key,
            post: post,
            callback: () => context.push('${Paths.postDetail}/${post.id}'),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
