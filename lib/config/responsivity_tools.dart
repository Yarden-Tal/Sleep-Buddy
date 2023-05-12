import 'package:flutter/widgets.dart';

/// Use screen width responsively
double width(BuildContext ctx) => MediaQuery.of(ctx).size.width;

/// Use screen height responsively
double height(BuildContext ctx) => MediaQuery.of(ctx).size.height;

/// Use screen orientation responsively
Orientation orientation(BuildContext ctx) => MediaQuery.of(ctx).orientation;

/// Target screens above 600px
bool isLargeScreen(BuildContext ctx) {
  bool isLargeScreen;
  width(ctx) > 600 ? isLargeScreen = true : isLargeScreen = false;
  return isLargeScreen;
}
