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
        decoration: const BoxDecoration(color: Color.fromARGB(247, 15, 22, 98)),
        padding: EdgeInsets.all(width(context) * 0.04),
        child: ListView(
          children: [
            const Divider(
              color: ConfigColors.disabledBtn,
              endIndent: 150,
              indent: 150,
              thickness: 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height(context) * 0.03),
              child: Center(
                  child: Text(
                "Pick a sound",
                style: TextStyle(
                  color: ConfigColors.activeTimerColor,
                  fontSize: width(context) * 0.08,
                ),
              )),
            ),
            ..._radioButtons()
          ],
        ));
  }

  Widget _radioButton(int index, String soundName, IconData icon) {
    return Wrap(children: [
      Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(208, 15, 22, 98), borderRadius: BorderRadius.all(Radius.circular(15))),
        child: RadioListTile(
            value: index,
            groupValue: selectedSound,
            onChanged: (val) {
              setSelectedRadio(val!);
            },
            title: Row(
              children: [
                Icon(
                  icon,
                  color: ConfigColors.activeTimerColor,
                  size: width(context) * 0.07,
                ),
                SizedBox(width: width(context) * 0.08),
                Text(formatSoundName(soundName),
                    style: TextStyle(color: ConfigColors.textColor, fontSize: width(context) * 0.06)),
              ],
            ),
            activeColor: ConfigColors.activeTimerColor),
      ),
      const Divider(
        color: Colors.transparent,
        thickness: 1,
      ),
    ]);
  }

  List<Theme> _radioButtons() {
    List<Theme> radioButtons = [];
    for (int i = 0; i < sounds.length; i++) {
      radioButtons.add(Theme(
          data: Theme.of(context).copyWith(unselectedWidgetColor: ConfigColors.backgroundColor),
          child: _radioButton(i + 1, sounds[i], icons[i])));
    }
    return radioButtons;
  }
}
