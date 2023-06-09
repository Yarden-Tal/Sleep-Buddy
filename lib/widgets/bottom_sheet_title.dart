import 'package:flutter/material.dart';
import 'package:white_noise/config/responsivity_tools.dart';

class BottomSheetTitle extends StatelessWidget {
  const BottomSheetTitle({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: height(context) * 0.02),
        child: Center(
            child: Text(
          "Pick a sound",
          style: TextStyle(
            color: const Color.fromARGB(255, 247, 239, 205),
            fontSize: width(context) * 0.08,
          ),
        )),
      );
}
