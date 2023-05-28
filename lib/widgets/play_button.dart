import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/responsivity_tools.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
    required this.noiseIsOn,
    required this.toggleButton,
    required this.isDarkMode,
    super.key,
  });

  final bool noiseIsOn;
  final Function toggleButton;
  final bool isDarkMode;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _fgColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _fgColorAnimation = ColorTween(
      begin: ConfigColors.textColor,
      end: widget.isDarkMode ? ConfigColors.primaryColor : LightModeColors.primaryColorLight,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: height(context) * 0.16),
        child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                      backgroundColor: widget.isDarkMode ? ConfigColors.primaryColor : LightModeColors.primaryColorLight,
                      foregroundColor: (_fgColorAnimation.value)),
                  onPressed: () => {
                        _controller.forward().then((value) => _controller.reverse()),
                        widget.toggleButton(),
                      },
                  child: toggleIcon(context));
            }));
  }

  double returnIconSize(BuildContext context) => width(context) * 0.25;

  /// Change icon by [widget.noiseIsOn]
  Widget toggleIcon(BuildContext context) => widget.noiseIsOn
      ? Icon(Icons.stop_rounded, size: returnIconSize(context))
      : Icon(Icons.play_arrow_rounded, size: returnIconSize(context));
}
