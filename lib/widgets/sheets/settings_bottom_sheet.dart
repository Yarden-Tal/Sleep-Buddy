import 'package:flutter/material.dart';
import 'package:white_noise/config/sounds.dart';
import 'package:white_noise/utils/sound_utils.dart';

class SettingsBottomSheet extends StatefulWidget {
  final dynamic changeSound;
  final int selectedSoundIndex;

  const SettingsBottomSheet({
    super.key,
    required this.changeSound,
    required this.selectedSoundIndex,
  });

  @override
  SettingsBottomSheetState createState() => SettingsBottomSheetState();
}

class SettingsBottomSheetState extends State<SettingsBottomSheet> {
  late int selectedSound;

  @override
  void initState() {
    super.initState();
    selectedSound = widget.selectedSoundIndex;
  }

  setSelectedRadio(int val) async => setState(() {
        selectedSound = val;
        widget.changeSound(val);
        Navigator.pop(context);
      });

  @override
  Widget build(BuildContext context) {
    List<RadioListTile> radioButtons = [];
    for (int i = 0; i < sounds.length; i++) {
      radioButtons.add(_radioButton(i + 1, sounds[i]));
    }
    return ListView(children: radioButtons);
  }

  RadioListTile _radioButton(int index, String soundName) {
    return RadioListTile(
      value: index,
      groupValue: selectedSound,
      onChanged: (val) {
        setSelectedRadio(val!);
      },
      title: Text(formatSoundName(soundName)),
    );
  }
}
