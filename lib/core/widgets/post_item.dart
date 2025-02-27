import 'package:flutter/material.dart';
import '../extensions/build_content_extensions.dart';
import '../extensions/widget_extensions.dart';
import '../utils/string_utils.dart';
import 'cache_image.dart';
import '../../features/post/domain/entities/post_entity.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.post,
    this.callback,
    this.border,
    this.isDetail = false,
  });
  final PostEntity post;
  final Border? border;
  final Function()? callback;
  final bool isDetail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          border: isDetail ? null : border ?? Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(20),
        child: (context.isMobile || isDetail) ? _columnPost(context) : _rowPost(context),
      ),
    );
  }

  Row _rowPost(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedImage(
          imageUrl: post.imageUrl,
          placeholder: SizedBox(
            width: 280,
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          ),
          width: 280,
          height: 150,
        ),
        20.sbW(),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(post.title, style: context.textTheme.titleLarge),
              Text(timeAgo(post.updatedAt), style: TextStyle(color: Colors.black54)),
              20.sbH(),
              Text(
                post.body,
                style: context.textTheme.bodyMedium,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _columnPost(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedImage(
          imageUrl: post.imageUrl,
          placeholder: SizedBox(
            height: 250,
            width: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          ),
          height: 250,
          width: double.infinity,
        ),
        20.sbH(),
        Text(post.title, style: context.textTheme.titleLarge),
        Text(timeAgo(post.updatedAt), style: TextStyle(color: Colors.black54)),
        20.sbH(),
        Text(
          post.body,
          style: context.textTheme.bodyLarge,
          maxLines: isDetail ? null : 5,
          overflow: isDetail ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
