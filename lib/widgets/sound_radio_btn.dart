import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/responsivity_tools.dart';
import 'package:white_noise/utils/utils.dart';

class SoundRadioBtn extends StatelessWidget {
  const SoundRadioBtn({super.key, required this.sound});

  final String sound;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Text(
            formatSoundName(sound),
            style: TextStyle(
              color: ConfigColors.textColor,
              fontSize: widthVar(context) * 0.075,
            ),
          ),
          onPressed: () {},
        ),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }
}
