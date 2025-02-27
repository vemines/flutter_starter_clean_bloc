import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter_starter_clean_bloc/core/extensions/build_content_extensions.dart';
import 'package:flutter_starter_clean_bloc/core/extensions/widget_extensions.dart';
import 'package:flutter_starter_clean_bloc/core/widgets/cache_image.dart';

PreferredSizeWidget buildAppBar(BuildContext context, String title, {List<Widget>? actions}) {
  return AppBar(
    title: Text(title, style: TextStyle(color: Colors.black)),
    centerTitle: true,
    elevation: 0,
    leading:
        Navigator.canPop(context)
            ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )
            : null,
    actions: actions,
  );
}

String loremGen({int? words = 6, int? paragraphs = 1}) =>
    lorem(paragraphs: paragraphs!, words: words!);

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    this.callback,
    this.border,
    this.timestamp,
    this.isDetail = false,
  });
  final int id;
  final String title;
  final String body;
  final Function()? callback;
  final Border? border;
  final DateTime? timestamp;
  final bool isDetail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          border: border ?? Border.all(color: Colors.black26),
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
      spacing: 20,
      children: [
        CachedImage(
          imageUrl: "https://picsum.photos/800/450?random=${id % 5}",
          placeholder: SizedBox(
            width: 280,
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          ),
          width: 280,
          height: 150,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: context.textTheme.titleLarge),
              Text("about a month ago", style: TextStyle(color: Colors.black54)),
              20.sbH(),
              Text(
                body,
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
          imageUrl: "https://picsum.photos/800/450?random=${id % 5}",
          placeholder: SizedBox(
            height: 250,
            width: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          ),
          height: 250,
          width: double.infinity,
        ),
        20.sbH(),
        Text(title, style: context.textTheme.titleLarge),
        Text("about a month ago", style: TextStyle(color: Colors.black54)),
        20.sbH(),
        Text(
          body,
          style: context.textTheme.bodyLarge,
          maxLines: isDetail ? null : 5,
          overflow: isDetail ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Page not found"),
            SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                // if (context.canPop())
                Navigator.pushNamed(context, '/home');
              },
              child: Text("Go home"),
            ),
          ],
        ),
      ),
    );
  }
}

Widget safeWrapContainer(
  BuildContext context,
  ScrollController scrollController,
  Widget child, {
  Border? border,
}) {
  return SingleChildScrollView(
    controller: scrollController,
    physics: AlwaysScrollableScrollPhysics(),
    child: Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1000, minHeight: context.safeHeight + 5),
        decoration: BoxDecoration(border: border, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    ),
  );
}
