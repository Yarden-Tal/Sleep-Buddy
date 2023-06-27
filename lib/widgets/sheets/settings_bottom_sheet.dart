import 'package:flutter/material.dart';
import 'package:white_noise/config/icons.dart';
import 'package:white_noise/config/responsivity_tools.dart';
import 'package:white_noise/config/sounds.dart';
import 'package:white_noise/utils/close_bottom_sheet.dart';
import 'package:white_noise/utils/color_getters.dart';
import 'package:white_noise/utils/sound_utils.dart';
import 'package:white_noise/widgets/bottom_sheet_title.dart';
import 'package:white_noise/widgets/customs/custom_sized_box.dart';
import 'package:white_noise/widgets/top_divider.dart';

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

  /// Change sound & selected-radio when another button is selected
  void _setSelectedRadio(int val) async => setState(() {
        selectedSound = val;
        widget.changeSound(val);
        closeBottomSheet(context);
      });

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        color: getBackgroundColor(widget.isDarkMode),
      ),
      padding: EdgeInsets.all(width(context) * 0.04),
      child: ListView(
        shrinkWrap: true,
        children: [
          const TopDivider(),
          const BottomSheetTitle(),
          ..._radioButtons(),
        ],
      ));

  List<Theme> _radioButtons() {
    List<Theme> radioButtons = [];
    for (int i = 0; i < sounds.length; i++) {
      radioButtons.add(Theme(
          data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.transparent),
          child: _radioButton(i + 1, sounds[i], icons[i])));
    }
    return radioButtons;
  }

  Wrap _radioButton(int index, String soundName, IconData icon) => Wrap(children: [
        Container(
          decoration:
              BoxDecoration(color: getBtnColor(widget.isDarkMode), borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: RadioListTile(
              value: index,
              groupValue: selectedSound,
              onChanged: (val) => _setSelectedRadio(val!),
              title: Row(
                children: [
                  if (isLargeScreen(context)) SizedBox(width: width(context) * 0.05),
                  Icon(
                    icon,
                    color: getIconColor(index, selectedSound, widget.isDarkMode),
                    size: width(context) * 0.07,
                  ),
                  SizedBox(width: width(context) * (isLargeScreen(context) ? 0.15 : 0.12)),
                  Text(formatSoundName(soundName),
                      style: TextStyle(
                        color: getBtnTextColor(index, selectedSound),
                        fontSize: width(context) * 0.06,
                      )),
                ],
              ),
              activeColor: Colors.transparent),
        ),
        CustomSizedBox(boxHeight: height(context) * 0.000015)
      ]);
}
