import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/responsivity_tools.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
    required this.noiseIsOn,
    required this.toggleButton,
    super.key,
  });

  final bool noiseIsOn;
  final Function toggleButton;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _bgColorAnimation;
  late Animation<Color?> _fgColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _bgColorAnimation = ColorTween(
      begin: ConfigColors.primaryColor,
      end: const Color.fromARGB(255, 49, 56, 135),
    ).animate(_controller);

    _fgColorAnimation = ColorTween(
      begin: ConfigColors.textColor,
      end: ConfigColors.primaryColor,
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
                    backgroundColor: (_bgColorAnimation.value),
                    foregroundColor: (_fgColorAnimation.value)),
                onPressed: () => {
                      _controller.forward().then((value) => _controller.reverse()),
                      widget.toggleButton(),
                    },
                child: toggleIcon(context));
          },
        ));
  }

  double returnIconSize(BuildContext context) {
    return width(context) * 0.25;
  }

  /// Change icon by [widget.noiseIsOn]
  Widget toggleIcon(BuildContext context) {
    return widget.noiseIsOn
        ? Icon(Icons.stop_rounded, size: returnIconSize(context))
        : Icon(
            Icons.play_arrow_rounded,
            size: returnIconSize(context),
            // shadows: applyShadow(),
          );
  }
}
