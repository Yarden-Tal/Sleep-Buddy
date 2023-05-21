import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/icons.dart';
import 'package:white_noise/config/responsivity_tools.dart';
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

  void setSelectedRadio(int val) async => setState(() {
        selectedSound = val;
        widget.changeSound(val);
        Navigator.pop(context);
      });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color.fromARGB(229, 15, 22, 98)),
        padding: EdgeInsets.all(width(context) * 0.04),
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView(
          children: _radioButtons(),
        ));
  }

  Wrap _radioButton(int index, String soundName, IconData icon) {
    return Wrap(children: [
      RadioListTile(
          value: index,
          groupValue: selectedSound,
          onChanged: (val) {
            setSelectedRadio(val!);
          },
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(formatSoundName(soundName), style: TextStyle(color: ConfigColors.textColor, fontSize: width(context) * 0.06)),
            // SizedBox(width: width(context) * 0.06), // Add some spacing between the icon and text
            Icon(
              icon,
              color: ConfigColors.activeTimerColor,
              size: width(context) * 0.06,
            )
          ]),
          activeColor: ConfigColors.activeTimerColor)
    ]);
  }

  List<Wrap> _radioButtons() {
    List<Wrap> radioButtons = [];
    for (int i = 0; i < sounds.length; i++) {
      radioButtons.add(_radioButton(i + 1, sounds[i], icons[i]));
    }
    return radioButtons;
  }
}
