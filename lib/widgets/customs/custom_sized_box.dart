import 'package:flutter/material.dart';
import './../../config/responsivity_tools.dart';

class CustomSizedBox extends StatelessWidget {
  final double boxHeight;
  const CustomSizedBox({super.key, required this.boxHeight});

  @override
  Widget build(BuildContext context) => Container(height: height(context) * boxHeight);
}
