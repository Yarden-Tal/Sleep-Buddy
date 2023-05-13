import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/responsivity_tools.dart';
import 'package:white_noise/config/shadow.dart';
import 'package:white_noise/config/sounds.dart';
import 'package:white_noise/settings_bottom_sheet.dart';
import 'package:white_noise/widgets/info_bottom_sheet.dart';
import 'package:white_noise/widgets/play_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _volume = 0;
  bool _iconShowsStop = false;
  bool audioIsPlaying = false;
  bool decreaseBtnIsDisabled = true;
  final chosenSound = AudioPlayer(playerId: "sound");
  int _seconds = 0;
  Timer? _timer;
  final Duration _stepDuration = const Duration(minutes: 30);

  @override
  void initState() {
    super.initState();

    /// Listen to system volume change
    VolumeController().listener((volume) => setState(() => _volume = volume));
    VolumeController().getVolume().then((volume) => _volume = volume);
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    chosenSound.dispose();
    _iconShowsStop = false;
    audioIsPlaying = false;
    _timer?.cancel();
    super.dispose();
  }

  /* FUNCTIONS */

  void _toggleBtn() async {
    await setSound();
    await toggleAudio();
    setState(() => _iconShowsStop = !_iconShowsStop);
  }

  Future setSound() async {
    await chosenSound.setReleaseMode(ReleaseMode.loop);
    await chosenSound.setSourceAsset(Sound.forest);
    // toggleAudio();
  }

  Future toggleAudio() async {
    if (audioIsPlaying) {
      await chosenSound.pause();
      _stopTimer();
    } else if (!audioIsPlaying) {
      await chosenSound.resume();
      _startTimer();
    }
    audioIsPlaying = !audioIsPlaying;
  }

  void handleVolumeChange(double value) {
    VolumeController().setVolume(_volume);
    setState(() => _volume = value);
  }

  void _startTimer() {
    if ((_timer != null && _timer!.isActive) || _seconds < 1) return;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_seconds < 1) {
                _iconShowsStop = false;
                toggleAudio();
                decreaseBtnIsDisabled = true;
                timer.cancel();
              } else {
                _seconds = _seconds - 1;
              }
            }));
  }

  void _stopTimer() => _timer?.cancel();

  void _addTime() => setState(() {
        _seconds += _stepDuration.inSeconds;
        decreaseBtnIsDisabled = false;
        if (audioIsPlaying) _startTimer();
      });

  void _subtractTime() => setState(() {
        if (_seconds >= _stepDuration.inSeconds) {
          _seconds -= _stepDuration.inSeconds;
        } else {
          _seconds = 0;
        }
      });

  String formatTimePart(int timePart) => timePart.toString().padLeft(2, '0');

  String computeTime() {
    String hours = formatTimePart(_seconds ~/ 3600);
    String minutes = formatTimePart((_seconds % 3600) ~/ 60);
    String seconds = formatTimePart(_seconds % 60);
    return '$hours:$minutes:$seconds';
  }

  /* BUILD */

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/background.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          titleTextStyle: TextStyle(fontSize: width(context) * 0.055),
          toolbarHeight: height(context) * 0.08,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: width(context) * 0.03),
              child: IconButton(
                  icon: Icon(
                    Icons.info,
                    size: height(context) * 0.04,
                  ),
                  tooltip: 'About the authors',
                  onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => const InfoBottomSheet(),
                      )),
            ),
          ],
          leading: GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => const SettingsBottomSheet(),
            ),
            child: Icon(
              Icons.music_note_outlined,
              size: height(context) * 0.04,
            ),
          ),
          centerTitle: true,
          backgroundColor: ConfigColors.primaryColor,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height(context) * 0.16),
                child: PlayButton(
                  noiseIsOn: _iconShowsStop,
                  toggleButton: _toggleBtn,
                ),
              ),
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    '',
                    style: TextStyle(fontSize: 24, color: ConfigColors.textColor),
                  ),
                  SizedBox(height: height(context) * 0.1),
                  Text(
                    computeTime(),
                    style: TextStyle(
                      fontSize: width(context) * 0.09,
                      color: ConfigColors.textColor,
                      fontWeight: FontWeight.normal,
                      shadows: applyShadow(),
                    ),
                  ),
                  SizedBox(height: height(context) * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _subtractTime,
                        onLongPressEnd: (_) => _stopTimer(),
                        child: Icon(
                          Icons.remove_circle,
                          color: decreaseBtnIsDisabled ? ConfigColors.disabledBtn : ConfigColors.textColor,
                          size: width(context) * 0.15,
                          shadows: applyShadow(),
                        ),
                      ),
                      GestureDetector(
                        onTap: _addTime,
                        onLongPressEnd: (_) => _stopTimer(),
                        child: Icon(
                          Icons.add_circle,
                          color: ConfigColors.textColor,
                          size: width(context) * 0.15,
                          shadows: applyShadow(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: isLargeScreen(context) ? EdgeInsets.symmetric(horizontal: width(context) * 0.15) : EdgeInsets.zero,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: height(context) * 0.01,
              ),
              child: Slider(
                  thumbColor: ConfigColors.textColor.withOpacity(0.8),
                  inactiveColor: ConfigColors.backgroundColor,
                  activeColor: ConfigColors.primaryColor,
                  min: 0,
                  max: 1,
                  value: _volume,
                  onChanged: (double value) => handleVolumeChange(value)),
            ),
          ),
        ],
        backgroundColor: ConfigColors.backgroundColor,
      ),
    );
  }
}
