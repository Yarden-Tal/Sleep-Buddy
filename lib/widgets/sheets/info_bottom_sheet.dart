import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';

class InfoBottomSheet extends StatefulWidget {
  const InfoBottomSheet({super.key});

  @override
  State<InfoBottomSheet> createState() => _InfoBottomSheet();
}

class _InfoBottomSheet extends State<InfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: ConfigColors.primaryColor),
        height: MediaQuery.of(context).size.height * 0.35,
        child: const Text(
          "About Yarden",
          style: TextStyle(color: ConfigColors.textColor),
        ));
  }
}
