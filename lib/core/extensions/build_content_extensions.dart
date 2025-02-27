import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  // usage: context.textTheme
  TextTheme get textTheme => Theme.of(this).textTheme;
  // usage: context.width
  double get width => MediaQuery.of(this).size.width;
  // usage: context.height
  double get height => MediaQuery.of(this).size.height;
  // usage: context.widthF(0.2)
  double widthF(double factor) => width * factor;
  // usage: context.heightF(0.2)
  double heightF(double factor) => height * factor;
  // usage: context.isMobile
  bool get isMobile => width < 768;

  // Safe area
  EdgeInsets get paddingOf => MediaQuery.paddingOf(this);
  // usage: context.safeHeight (-n necause still left scroll, if need scroll more add + n)
  double get safeHeight =>
      height -
      paddingOf.top -
      paddingOf.bottom -
      AppBar().preferredSize.height -
      kBottomNavigationBarHeight -
      5;

  // usage: context.colorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
