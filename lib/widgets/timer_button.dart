import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/responsivity_tools.dart';
import 'package:white_noise/config/shadow.dart';

class TimerButton extends StatefulWidget {
  const TimerButton({
    required this.seconds,
    required this.onTapColor,
    required this.icon,
    required this.func,
    super.key,
    required this.isDarkmode,
  });

  final int seconds;
  final bool onTapColor;
  final IconData icon;
  final void Function()? func;
  final bool isDarkmode;

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  @override
  GestureDetector build(BuildContext context) => GestureDetector(
        onTap: widget.func,
        child: Icon(
          widget.icon,
          color: widget.icon == Icons.remove_circle && widget.seconds < 1
              ? widget.isDarkmode
                  ? ConfigColors.disabledBtn
                  : LightModeColors.disabledBtnLight
              : (widget.onTapColor == true ? ConfigColors.activeTimerColor : ConfigColors.textColor),
          size: width(context) * 0.15,
          shadows: applyShadow(),
        ),
      );
}
