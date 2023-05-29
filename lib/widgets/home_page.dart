import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/fonts.dart';
import 'package:white_noise/config/responsivity_tools.dart';
import 'package:white_noise/config/shadow.dart';
import 'package:white_noise/config/sounds.dart';
import 'package:white_noise/widgets/customs/custom_button.dart';
import 'package:white_noise/widgets/customs/custom_sized_box.dart';
import 'package:white_noise/widgets/sheets/settings_bottom_sheet.dart';
import 'package:white_noise/utils/time_utils.dart';
import 'package:white_noise/widgets/play_button.dart';
import 'package:white_noise/widgets/timer_button.dart';

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
  final Duration _stepDuration = const Duration(minutes: 30);
  int selectedSoundIndex = 1;
  int _seconds = 0;
  Timer? _timer;
  bool colorAddButton = false;
  bool colorSubtractButton = false;
  bool isDarkMode = true;

  @override
  void initState() {
    audioPlayer.setSourceAsset(sounds[0]);
    selectedSoundIndex = 1;
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _iconShowsStop = false;
    audioIsPlaying = false;
    colorAddButton = false;
    colorSubtractButton = false;
    _timer?.cancel();
    super.dispose();
  }

  /* FUNCTIONS */

  void _toggleBtn() async {
    await _toggleAudio();
    setState(() => _iconShowsStop = !_iconShowsStop);
  }

  Future<void> _changeSound(int newSound) async {
    if (newSound >= 1 && newSound <= sounds.length) {
      String selectedSound = sounds[newSound - 1];
      await audioPlayer.setSourceAsset(selectedSound);
      setState(() => selectedSoundIndex = newSound);
    }
  }

  Future _toggleAudio() async {
    if (audioIsPlaying) {
      await audioPlayer.pause();
      _stopTimer();
    } else if (!audioIsPlaying) {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.resume();
      _startTimer();
    }
    audioIsPlaying = !audioIsPlaying;
  }

  void _startTimer() {
    if ((_timer != null && _timer!.isActive) || _seconds < 1) return;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_seconds < 1) {
                _iconShowsStop = false;
                _toggleAudio();
                _stopTimer();
              } else {
                _seconds--;
              }
            }));
  }

  void _stopTimer() => _timer?.cancel();

  void _addTime() => setState(() {
        Timer(const Duration(milliseconds: 100), () {
          setState(() => colorAddButton = false);
        });
        _seconds += _stepDuration.inSeconds;
        if (audioIsPlaying) _startTimer();
        setState(() => colorAddButton = true);
      });

  void _subtractTime() => setState(() {
        if (_seconds >= _stepDuration.inSeconds) {
          Timer(const Duration(milliseconds: 100), () {
            setState(() => colorSubtractButton = false);
          });
          _seconds -= _stepDuration.inSeconds;
          setState(() => colorSubtractButton = true);
        } else {
          _seconds = 0;
        }
      });

  /* BUILD */

  @override
  Container build(BuildContext context) => Container(
        decoration: backgroundImg(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: _appBar(context),
          body: Center(
            child: PlayButton(
              noiseIsOn: _iconShowsStop,
              toggleButton: _toggleBtn,
              isDarkMode: isDarkMode,
            ),
          ),
          backgroundColor: ConfigColors.backgroundColor.withOpacity(0),
          persistentFooterButtons: [
            _timerSection(context),
          ],
        ),
      );

// Local widgets
  BoxDecoration backgroundImg() => BoxDecoration(
          image: DecorationImage(
        image: AssetImage(isDarkMode ? "assets/images/background.png" : "assets/images/background-light.png"),
        fit: BoxFit.cover,
      ));

  AppBar _appBar(BuildContext context) => AppBar(
        titleTextStyle: TextStyle(
          fontSize: width(context) * 0.085,
          fontFamily: ConfigFonts.primaryFont,
        ),
        toolbarHeight: height(context) * 0.08,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: width(context) * 0.04),
              child: CustomButton(
                bottomSheet: SettingsBottomSheet(
                  changeSound: _changeSound,
                  selectedSoundIndex: selectedSoundIndex,
                  isDarkMode: isDarkMode,
                ),
                icon: Icons.settings,
              ))
        ],
        leading: Padding(
          padding: EdgeInsets.only(left: width(context) * 0.03),
          child: IconButton(
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
            icon: Icon(
              isDarkMode ? Icons.sunny : Icons.nightlight,
              color: isDarkMode ? ConfigColors.activeTimerColor : ConfigColors.textColor,
              size: height(context) * 0.04,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? ConfigColors.primaryColor : LightModeColors.primaryColorLight,
        title: Text(widget.title),
      );

  Column _timerSection(BuildContext context) => Column(
        children: [
          const CustomSizedBox(boxHeight: 0.1),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: isDarkMode ? ConfigColors.timerBackground : LightModeColors.timerBackgroundLight,
            ),
            width: width(context) * 0.9,
            padding: EdgeInsets.symmetric(vertical: height(context) * 0.02),
            child: Column(
              children: <Widget>[
                Icon(
                  _seconds < 1 ? Icons.timer_off : Icons.timer,
                  color: _seconds < 1
                      ? ConfigColors.disabledBtn
                      : (audioIsPlaying ? ConfigColors.activeTimerColor : ConfigColors.textColor),
                  size: width(context) * 0.11,
                  shadows: applyShadow(),
                ),
                const CustomSizedBox(boxHeight: 0.01),
                Text(
                  computeTime(_seconds),
                  style: TextStyle(
                    fontSize: width(context) * 0.1,
                    color: _seconds < 1
                        ? ConfigColors.disabledBtn
                        : (audioIsPlaying ? ConfigColors.activeTimerColor : ConfigColors.textColor),
                    fontWeight: FontWeight.normal,
                    shadows: applyShadow(),
                  ),
                ),
                const CustomSizedBox(boxHeight: 0.025),
                _timerButtons(),
              ],
            ),
          ),
        ],
      );

  Row _timerButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TimerButton(
            seconds: _seconds,
            isTapColor: colorSubtractButton,
            icon: Icons.remove_circle,
            func: _subtractTime,
          ),
          TimerButton(
            seconds: _seconds,
            isTapColor: colorAddButton,
            icon: Icons.add_circle,
            func: _addTime,
          ),
        ],
      );
}
