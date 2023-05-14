import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/sounds.dart';
import 'package:white_noise/widgets/sound_radio_btn.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: ConfigColors.primaryColor),
        height: MediaQuery.of(context).size.height * 0.35,
        child: const Column(
          children: [
            SoundRadioBtn(
              sound: Sound.generic,
            ),
            SoundRadioBtn(
              sound: Sound.forest,
            ),
            SoundRadioBtn(
              sound: Sound.rain,
            ),
            SoundRadioBtn(
              sound: Sound.waves,
            ),
          ],
        ));
  }
}
