import 'package:flutter/widgets.dart';

/// Use screen width responsively
double widthVar(BuildContext ctx) => MediaQuery.of(ctx).size.width;

/// Use screen height responsively
double heightVar(BuildContext ctx) => MediaQuery.of(ctx).size.height;

/// Use screen orientation responsively
Orientation orientationVar(BuildContext ctx) => MediaQuery.of(ctx).orientation;
