import 'package:flutter/material.dart';
import 'package:white_noise/config/responsivity_tools.dart';
import 'package:white_noise/widgets/customs/custom_button.dart';
import 'package:white_noise/widgets/sheets/settings_bottom_sheet.dart';

List<Widget> settingsButton(BuildContext context, bool isDarkMode, Function changeSound, int selectedSoundIndex) => <Widget>[
      Padding(
          padding: EdgeInsets.only(right: width(context) * 0.04),
          child: CustomButton(
            bottomSheet: SettingsBottomSheet(
              changeSound: changeSound,
              selectedSoundIndex: selectedSoundIndex,
              isDarkMode: isDarkMode,
            ),
            icon: Icons.settings,
          ))
    ];
