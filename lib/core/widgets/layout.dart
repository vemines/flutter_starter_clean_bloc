import 'package:flutter/material.dart';

import '../extensions/build_content_extensions.dart';

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
