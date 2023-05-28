import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/icons.dart';
import 'package:white_noise/config/responsivity_tools.dart';
import 'package:white_noise/config/sounds.dart';
import 'package:white_noise/utils/sound_utils.dart';

class SettingsBottomSheet extends StatefulWidget {
  final dynamic changeSound;
  final int selectedSoundIndex;
  final bool isDarkMode;

  const SettingsBottomSheet({
    super.key,
    required this.changeSound,
    required this.selectedSoundIndex,
    required this.isDarkMode,
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
        Navigator.pop(context);
        selectedSound = val;
        widget.changeSound(val);
      });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color.fromARGB(247, 15, 22, 98) : LightModeColors.primaryColorLight,
        ),
        padding: EdgeInsets.all(width(context) * 0.04),
        child: ListView(
          children: [
            Divider(
              color: ConfigColors.disabledBtn,
              endIndent: width(context) * 0.4,
              indent: width(context) * 0.4,
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

  List<Theme> _radioButtons() {
    List<Theme> radioButtons = [];
    for (int i = 0; i < sounds.length; i++) {
      radioButtons.add(Theme(
          data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.transparent),
          child: _radioButton(i + 1, sounds[i], icons[i])));
    }
    return radioButtons;
  }

  Wrap _radioButton(int index, String soundName, IconData icon) {
    return Wrap(children: [
      Container(
        decoration: BoxDecoration(
            color: widget.isDarkMode ? const Color.fromARGB(208, 15, 22, 98) : ConfigColors.disabledBtn,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: RadioListTile(
            value: index,
            groupValue: selectedSound,
            onChanged: (val) => setSelectedRadio(val!),
            title: Row(
              children: [
                if (isLargeScreen(context)) SizedBox(width: width(context) * 0.05),
                Icon(
                  icon,
                  color: index == selectedSound
                      ? ConfigColors.activeTimerColor
                      : (widget.isDarkMode ? ConfigColors.disabledBtn : LightModeColors.disabledBtnLight),
                  size: width(context) * 0.07,
                ),
                SizedBox(width: width(context) * (isLargeScreen(context) ? 0.15 : 0.12)),
                Text(formatSoundName(soundName),
                    style: TextStyle(
                        color: index != selectedSound ? ConfigColors.textColor.withOpacity(0.4) : ConfigColors.textColor,
                        fontSize: width(context) * 0.06)),
              ],
            ),
            activeColor: Colors.transparent),
      ),
      const Divider(
        color: Colors.transparent,
        thickness: 1,
      ),
    ]);
  }
}
