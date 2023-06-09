import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:flutter/material.dart';
import 'package:white_noise/config/fonts.dart';
import 'package:white_noise/config/responsivity_tools.dart';
import 'package:white_noise/config/shadow.dart';
import 'package:white_noise/config/sounds.dart';
import 'package:white_noise/utils/color_getters.dart';
import 'package:white_noise/utils/get_snack_bar.dart';
import 'package:white_noise/widgets/bck_image.dart';
import 'package:white_noise/widgets/customs/custom_sized_box.dart';
import 'package:white_noise/widgets/settings_btn.dart';
import 'package:white_noise/utils/time_utils.dart';
import 'package:white_noise/widgets/play_button.dart';
import 'package:white_noise/widgets/timer_buttons.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _iconShowsStop = false;
  bool audioIsPlaying = false;
  final audioPlayer = AudioPlayer(playerId: "sound");
  // final audioPlayer2 = AudioPlayer(playerId: "sound2");
  final _stepDuration = const Duration(minutes: 30);
  int selectedSoundIndex = 1;
  int seconds = 0;
  Timer? _timer;
  bool colorAddButton = false;
  bool colorSubtractButton = false;
  bool isDarkMode = true;
  double _volumeListenerValue = 1;

  @override
  void initState() {
    audioPlayer.setSourceAsset(sounds[0]);
    // audioPlayer2.setSourceAsset(sounds[0]);
    selectedSoundIndex = 1;
    VolumeController().listener((volume) => setState(() => _volumeListenerValue = volume));
    VolumeController().getVolume().then((volume) => _volumeListenerValue = volume);
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    // audioPlayer2.dispose();
    _iconShowsStop = false;
    audioIsPlaying = false;
    colorAddButton = false;
    colorSubtractButton = false;
    _timer?.cancel();
    VolumeController().removeListener();
    super.dispose();
  }

  /* FUNCTIONS */

  void _toggleBtn() async {
    await _toggleAudio();
    setState(() => _iconShowsStop = !_iconShowsStop);
  }

  Future<void> changeSound(int newSound) async {
    if (newSound >= 1 && newSound <= sounds.length) {
      String selectedSound = sounds[newSound - 1];
      await audioPlayer.setSourceAsset(selectedSound);
      // await audioPlayer2.setSourceAsset(selectedSound);
      setState(() => selectedSoundIndex = newSound);
    }
  }

  Future _toggleAudio() async {
    if (audioIsPlaying) {
      await audioPlayer.pause();
      // await audioPlayer2.pause();
      _stopTimer();
    } else if (!audioIsPlaying) {
      VolumeController().listener((volume) => setState(() => _volumeListenerValue = volume));
      VolumeController().getVolume().then((volume) {
        setState(() => _volumeListenerValue = volume);
        getSnackBar(_volumeListenerValue, context);
      });
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.setPlayerMode(PlayerMode.lowLatency);
      // await audioPlayer.setVolume(0.7);
      await audioPlayer.resume();
      Timer(const Duration(seconds: 3), () async {
        // await audioPlayer2.setReleaseMode(ReleaseMode.loop);
        // await audioPlayer2.setPlayerMode(PlayerMode.lowLatency);
        // await audioPlayer2.setVolume(0.5);
        // await audioPlayer.setVolume(0.5);
        // await audioPlayer2.resume();
      });
      _startTimer();
    }
    audioIsPlaying = !audioIsPlaying;
  }

  void _startTimer() {
    if ((_timer != null && _timer!.isActive) || seconds < 1) return;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (seconds < 1) {
                _iconShowsStop = false;
                _toggleAudio();
                _stopTimer();
              } else {
                seconds--;
              }
            }));
  }

  void _stopTimer() => _timer?.cancel();

  void addTime() => setState(() {
        Timer(const Duration(milliseconds: 100), () {
          setState(() => colorAddButton = false);
        });
        seconds += _stepDuration.inSeconds;
        if (audioIsPlaying) _startTimer();
        setState(() => colorAddButton = true);
      });

  void subtractTime() => setState(() {
        if (seconds >= _stepDuration.inSeconds) {
          Timer(const Duration(milliseconds: 100), () {
            setState(() => colorSubtractButton = false);
          });
          seconds -= _stepDuration.inSeconds;
          setState(() => colorSubtractButton = true);
        } else {
          seconds = 0;
        }
      });

  /* BUILD */

  @override
  Container build(BuildContext context) => Container(
        decoration: backgroundImg(isDarkMode),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: _appBar(context),
          body: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.vertical,
            children: [
              CustomSizedBox(boxHeight: height(context) * 0.000001),
              PlayButton(noiseIsOn: _iconShowsStop, toggleButton: _toggleBtn, isDarkMode: isDarkMode),
              _timerSection(context),
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
      );

// Local widgets

  AppBar _appBar(BuildContext context) => AppBar(
        titleTextStyle: TextStyle(
          fontSize: width(context) * 0.085,
          fontFamily: ConfigFonts.primaryFont,
        ),
        toolbarHeight: height(context) * 0.08,
        actions: settingsButton(context, isDarkMode, changeSound, selectedSoundIndex),
        leading: _darkModeButton(context),
        centerTitle: true,
        backgroundColor: getAppbarBckColor(isDarkMode),
        title: Text(widget.title),
      );

  Padding _darkModeButton(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: width(context) * 0.03),
        child: IconButton(
          onPressed: () => setState(() => isDarkMode = !isDarkMode),
          icon: Icon(
            isDarkMode ? Icons.sunny : Icons.nightlight,
            color: getDarkModeIconColor(isDarkMode),
            size: height(context) * 0.04,
          ),
        ),
      );

  Column _timerSection(BuildContext context) => Column(
        children: [
          const CustomSizedBox(boxHeight: 0.1),
          Container(
            margin: EdgeInsets.only(bottom: height(context) * 0.02),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: getTimerBck(isDarkMode),
            ),
            width: width(context) * 0.9,
            padding: EdgeInsets.symmetric(vertical: height(context) * 0.02),
            child: Column(
              children: <Widget>[
                Icon(
                  seconds < 1 ? Icons.timer_off : Icons.timer,
                  color: getTimerIconAndTxtColor(seconds, isDarkMode, audioIsPlaying),
                  size: width(context) * 0.11,
                  shadows: applyShadow(),
                ),
                const CustomSizedBox(boxHeight: 0.007),
                Text(
                  computeTime(seconds),
                  style: TextStyle(
                    fontSize: width(context) * 0.1,
                    color: getTimerIconAndTxtColor(seconds, isDarkMode, audioIsPlaying),
                    fontWeight: FontWeight.normal,
                    shadows: applyShadow(),
                  ),
                ),
                const CustomSizedBox(boxHeight: 0.007),
                timerButtons(seconds, colorSubtractButton, subtractTime, isDarkMode, colorAddButton, addTime),
              ],
            ),
          ),
        ],
      );
}
