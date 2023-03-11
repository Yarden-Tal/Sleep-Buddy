import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';

/// PlayButton receives a [noiseIsOn] boolean, which toggles play and pause icons
class PlayButton extends StatelessWidget {
  const PlayButton({
    required this.noiseIsOn,
    required this.toggleButton,
    super.key,
  });

  final bool noiseIsOn;
  final Function toggleButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(24),
          backgroundColor: ConfigColors.primaryColor,
        ),
        onPressed: () => toggleButton(),
        child: toggleIcon());
  }

  /// Change icon by [noiseIsOn]
  Widget toggleIcon() {
    double iconSize = 85;
    return noiseIsOn
        ? Icon(Icons.stop_rounded, size: iconSize)
        : Icon(
            Icons.play_arrow_rounded,
            size: iconSize,
          );
  }
}
