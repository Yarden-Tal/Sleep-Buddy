import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';

Color getBtnColor(bool isDarkMode) => isDarkMode ? ConfigColors.disabledBtn : LightModeColors.disabledBtnLight;

Color getBackgroundColor(bool isDarkMode) => isDarkMode ? ConfigColors.primaryColor : LightModeColors.primaryColorLight;

Color getBtnTextColor(int index, int selectedSound) =>
    index != selectedSound ? ConfigColors.textColor.withOpacity(0.4) : ConfigColors.textColor;

Color getIconColor(int index, int selectedSound, bool isDarkMode) => index == selectedSound
    ? isDarkMode
        ? ConfigColors.activeTimerColor
        : const Color.fromARGB(255, 243, 233, 192)
    : (isDarkMode ? ConfigColors.disabledBtn : const Color.fromARGB(255, 80, 57, 88));

Color getTimerBck(bool isDarkMode) => isDarkMode ? ConfigColors.timerBackground : LightModeColors.timerBackgroundLight;

Color getTimerIconAndTxtColor(int seconds, bool isDarkMode, bool audioIsPlaying) => seconds < 1
    ? isDarkMode
        ? ConfigColors.disabledBtn
        : LightModeColors.disabledBtnLight
    : (audioIsPlaying ? ConfigColors.activeTimerColor : ConfigColors.textColor);

Color getDarkModeIconColor(bool isDarkMode) => isDarkMode ? ConfigColors.activeTimerColor : ConfigColors.textColor;

Color getAppbarBckColor(bool isDarkMode) => isDarkMode ? ConfigColors.primaryColor : LightModeColors.primaryColorLight;
