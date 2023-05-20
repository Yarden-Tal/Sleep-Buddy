// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:white_noise/config/responsivity_tools.dart';

class CustomButton extends StatelessWidget {
  final Widget bottomSheet;
  final IconData icon;

  const CustomButton({Key? key, required this.bottomSheet, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          icon,
          size: height(context) * 0.04,
        ),
        onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => bottomSheet,
            ));
  }
}
