import 'dart:async';

import 'package:flutter/material.dart';

void closeBottomSheet(BuildContext context) {
  Timer(const Duration(milliseconds: 300), () => Navigator.pop(context));
}