import 'dart:async';

import 'package:flutter/material.dart';
// Libraries
import 'package:audioplayers/audioplayers.dart';
import 'package:volume_controller/volume_controller.dart';
// Config
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/fonts.dart';
import 'package:white_noise/config/responsivity_tools.dart';
import 'package:white_noise/config/shadow.dart';
import 'package:white_noise/config/sounds.dart';
import 'package:white_noise/settings_bottom_sheet.dart';
import 'package:white_noise/widgets/info_bottom_sheet.dart';
// Widgets
import 'package:white_noise/widgets/play_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Buddy',
      theme: ThemeData(
        primaryColor: ConfigColors.primaryColor,
        fontFamily: ConfigFonts.primaryFont,
        fontFamilyFallback: ConfigFonts.fallBackFonts,
      ),
      home: const MyHomePage(
        title: 'Sleep Buddy',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _volume = 0;
  bool _iconShowsPlay = false;
  bool audioIsPlaying = false;
  final chosenSound = AudioPlayer(playerId: "sound");
  int _seconds = 0;
  Timer? _timer;
  final Duration _stepDuration = const Duration(seconds: 5);

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
    _iconShowsPlay = false;
    audioIsPlaying = false;
    _timer?.cancel();
    super.dispose();
  }

  /* FUNCTIONS */

  void _toggleBtn() {
    setSound();
    setState(() => _iconShowsPlay = !_iconShowsPlay);
  }

  Future setSound() async {
    await chosenSound.setReleaseMode(ReleaseMode.loop);
    await chosenSound.setSourceAsset(Sound.forest);
    toggleAudio();
  }

  Future toggleAudio() async {
    audioIsPlaying ? await chosenSound.pause() : await chosenSound.resume();
    !audioIsPlaying ? _startTimer() : _stopTimer();
    audioIsPlaying = !audioIsPlaying;
  }

  void handleVolumeChange(double value) {
    VolumeController().setVolume(_volume);
    setState(() => _volume = value);
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_seconds < 1) {
                _iconShowsPlay = false;
                audioIsPlaying = false;
                timer.cancel();
              } else {
                _seconds = _seconds - 1;
              }
            }));
  }

  void _stopTimer() => _timer?.cancel();

  void _addTime() => setState(() {
        _seconds += _stepDuration.inSeconds;
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info),
              tooltip: 'About the authors',
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const InfoBottomSheet();
                    });
              },
            ),
          ],
          leading: GestureDetector(
            onTap: () => showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const SettingsBottomSheet();
                }),
            child: const Icon(
              Icons.music_note_outlined,
              size: 30,
            ),
          ),
          centerTitle: true,
          backgroundColor: ConfigColors.primaryColor,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height(context) * 0.16),
                child: PlayButton(
                  noiseIsOn: _iconShowsPlay,
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
                  const SizedBox(height: 20),
                  Text(
                    computeTime(),
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
                        onLongPressEnd: (_) => _stopTimer(),
                        child: Icon(
                          Icons.remove_circle,
                          color: _seconds == 0 ? ConfigColors.disabledBtn : ConfigColors.textColor,
                          size: 55,
                          shadows: applyShadow(),
                        ),
                      ),
                      GestureDetector(
                        onTap: _addTime,
                        onLongPressEnd: (_) => _stopTimer(),
                        child: Icon(
                          Icons.add_circle,
                          color: ConfigColors.textColor,
                          size: 55,
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
          Slider(
              thumbColor: ConfigColors.textColor.withOpacity(0.8),
              inactiveColor: ConfigColors.backgroundColor,
              activeColor: ConfigColors.primaryColor,
              min: 0,
              max: 1,
              value: _volume,
              onChanged: (double value) => handleVolumeChange(value)),
        ],
        backgroundColor: ConfigColors.backgroundColor,
      ),
    );
  }
}
