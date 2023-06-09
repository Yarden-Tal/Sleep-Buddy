import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/responsivity_tools.dart';

class TopDivider extends StatelessWidget {
  const TopDivider({super.key});

  @override
  Divider build(BuildContext context) => Divider(
        color: ConfigColors.disabledBtn,
        endIndent: width(context) * 0.4,
        indent: width(context) * 0.4,
        thickness: 2,
      );
}
