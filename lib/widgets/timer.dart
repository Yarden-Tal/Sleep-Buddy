import 'dart:async';
import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  int _seconds = 0;
  Timer? _timer;
  final Duration _stepDuration = const Duration(minutes: 5);
  final Duration _longPressDuration = const Duration(seconds: 1);

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_seconds < 1) {
            timer.cancel();
          } else {
            _seconds = _seconds - 1;
          }
        },
      ),
    );
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _addTime() {
    setState(() {
      _seconds += _stepDuration.inSeconds;
    });
  }

  void _subtractTime() {
    setState(() {
      if (_seconds >= _stepDuration.inSeconds) {
        _seconds -= _stepDuration.inSeconds;
      }
    });
  }

  void _longPressAddTime() {
    _addTime();
    _timer = Timer.periodic(
      _longPressDuration,
      (timer) {
        _addTime();
      },
    );
  }

  void _longPressSubtractTime() {
    _subtractTime();
    _timer = Timer.periodic(
      _longPressDuration,
      (timer) {
        _subtractTime();
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 50,
        ),
        const Text(
          '',
          style: TextStyle(fontSize: 24, color: ConfigColors.textColor),
        ),
        const SizedBox(height: 20),
        Text(
          _seconds == 0
              ? "Timer"
              : '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(
              fontSize: 48,
              color: ConfigColors.textColor,
              fontWeight: FontWeight.normal,
              shadows: [Shadow(color: Colors.black87, blurRadius: 40, offset: Offset(0, 2))]),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: _subtractTime,
              onLongPressStart: (_) => _longPressSubtractTime(),
              onLongPressEnd: (_) => _stopTimer(),
              child: const Icon(
                Icons.remove_circle,
                color: ConfigColors.textColor,
                size: 55,
                shadows: [Shadow(color: Colors.black87, blurRadius: 40, offset: Offset(0, 2))],
              ),
            ),
            GestureDetector(
              onTap: _addTime,
              onLongPressStart: (_) => _longPressAddTime(),
              onLongPressEnd: (_) => _stopTimer(),
              child: const Icon(
                Icons.add_circle,
                color: ConfigColors.textColor,
                size: 55,
                shadows: [Shadow(color: Colors.black87, blurRadius: 40, offset: Offset(0, 2))],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
