import 'dart:async';

import 'package:flutter/material.dart';
// Libraries
import 'package:audioplayers/audioplayers.dart';
import 'package:volume_controller/volume_controller.dart';
// Config
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/fonts.dart';
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
  /// Volume state
  double _volumeListenerValue = 0;

  /// Button toggle start/stop icons
  bool _noiseIsOn = false;

  /// Audio toggle start/stop
  bool isPlaying = false;

  /// Audio [Sound] chosen
  final chosenSound = AudioPlayer(playerId: "sound");

  @override
  void initState() {
    super.initState();

    /// Listen to system volume change
    VolumeController().listener((volume) => setState(() => _volumeListenerValue = volume));
    VolumeController().getVolume().then((volume) => _volumeListenerValue = volume);
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    chosenSound.dispose();
    _noiseIsOn = false;
    isPlaying = false;
    _timer?.cancel();
    super.dispose();
  }

  void _toggleBtn() {
    setSound();
    setState(() => _noiseIsOn = !_noiseIsOn);
  }

  Future setSound() async {
    /// Loop the audio track
    await chosenSound.setReleaseMode(ReleaseMode.loop);
    await chosenSound.setSourceAsset(Sound.forest);
    toggleAudio();
  }

  Future toggleAudio() async {
    isPlaying ? await chosenSound.pause() : await chosenSound.resume();
    !isPlaying ? _startTimer() : _stopTimer();
    isPlaying = !isPlaying;
  }

  void handleVolumeChange(double value) {
    VolumeController().setVolume(_volumeListenerValue);
    setState(() => _volumeListenerValue = value);
  }

  int _seconds = 0;
  Timer? _timer;
  final Duration _stepDuration = const Duration(seconds: 5);

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_seconds < 1) {
                _noiseIsOn = false;
                isPlaying = false;
                timer.cancel();
              } else {
                _seconds = _seconds - 1;
              }
            }));
  }

  void _stopTimer() => _timer?.cancel();

  void _addTime() => setState(() {
        _seconds += _stepDuration.inSeconds;
        if (isPlaying) _startTimer();
      });

  void _subtractTime() => setState(() {
        if (_seconds >= _stepDuration.inSeconds) {
          _seconds -= _stepDuration.inSeconds;
        } else {
          _seconds = 0;
        }
      });

  @override
  Widget build(BuildContext context) {
    int hours = _seconds ~/ 3600;
    int minutes = (_seconds % 3600) ~/ 60;
    int seconds = _seconds % 60;
    String computedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

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
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.16),
                child: PlayButton(
                  noiseIsOn: _noiseIsOn,
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
                    computedTime,
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
                          shadows: const [Shadow(color: Colors.black87, blurRadius: 40, offset: Offset(0, 2))],
                        ),
                      ),
                      GestureDetector(
                        onTap: _addTime,
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
              value: _volumeListenerValue,
              onChanged: (double value) => handleVolumeChange(value)),
        ],
        backgroundColor: ConfigColors.backgroundColor,
      ),
    );
  }
}
