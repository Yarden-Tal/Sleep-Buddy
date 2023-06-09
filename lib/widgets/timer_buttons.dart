import 'package:flutter/material.dart';
import 'package:white_noise/widgets/timer_button.dart';

Row timerButtons(
  int seconds,
  bool colorSubtractButton,
  void Function()? subtractTime,
  bool isDarkMode,
  bool colorAddButton,
  void Function()? addTime,
) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TimerButton(
            seconds: seconds,
            onTapColor: colorSubtractButton,
            icon: Icons.remove_circle,
            func: subtractTime,
            isDarkmode: isDarkMode),
        TimerButton(
          seconds: seconds,
          onTapColor: colorAddButton,
          icon: Icons.add_circle,
          func: addTime,
          isDarkmode: isDarkMode,
        ),
      ],
    );
