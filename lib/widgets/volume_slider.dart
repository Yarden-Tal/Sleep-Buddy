import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';

class VolumeSlider extends StatelessWidget {
  const VolumeSlider({
    required this.volume,
    required this.func,
    super.key,
  });

  final double volume;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return Slider(
        thumbColor: ConfigColors.textColor.withOpacity(0.8),
        inactiveColor: ConfigColors.backgroundColor,
        activeColor: ConfigColors.primaryColor,
        min: 0,
        max: 1,
        onChanged: (value) => func,
        value: volume);
  }
}
