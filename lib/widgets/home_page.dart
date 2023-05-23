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
import 'package:white_noise/widgets/sheets/info_bottom_sheet.dart';
import 'package:white_noise/widgets/play_button.dart';

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
          setState(() {
            colorAddButton = false;
          });
        });
        _seconds += _stepDuration.inSeconds;
        if (audioIsPlaying) _startTimer();
        setState(() {
          colorAddButton = true;
        });
      });

  void _subtractTime() => setState(() {
        if (_seconds >= _stepDuration.inSeconds) {
          Timer(const Duration(milliseconds: 100), () {
            setState(() {
              colorSubtractButton = false;
            });
          });
          _seconds -= _stepDuration.inSeconds;
          setState(() {
            colorSubtractButton = true;
          });
        } else {
          _seconds = 0;
        }
      });

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
          titleTextStyle: TextStyle(
            fontSize: width(context) * 0.065,
            fontFamily: ConfigFonts.primaryFont,
          ),
          toolbarHeight: height(context) * 0.08,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: width(context) * 0.03),
                child: CustomButton(
                  bottomSheet: SettingsBottomSheet(
                    changeSound: _changeSound,
                    selectedSoundIndex: selectedSoundIndex,
                  ),
                  icon: Icons.settings,
                ))
          ],
          leading: Padding(
            padding: EdgeInsets.only(left: width(context) * 0.03),
            child: const CustomButton(
              bottomSheet: InfoBottomSheet(),
              icon: Icons.info,
            ),
          ),
          centerTitle: true,
          backgroundColor: ConfigColors.primaryColor,
          title: Text(widget.title),
        ),
        /* BODY */
        body: Center(
          child: Column(
            children: <Widget>[
              PlayButton(
                noiseIsOn: _iconShowsStop,
                toggleButton: _toggleBtn,
              ),
            ],
          ),
        ),
        backgroundColor: ConfigColors.backgroundColor,
        persistentFooterButtons: [
          Column(
            children: [
              const CustomSizedBox(boxHeight: 0.2),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: ConfigColors.timerBackground,
                ),
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
                    /* TIMER BUTTONS */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: _subtractTime,
                          // onLongPressStart: (_) => _stopTimer(),
                          child: Icon(
                            Icons.remove_circle,
                            color: _seconds < 1
                                ? ConfigColors.disabledBtn
                                : (colorSubtractButton == true ? ConfigColors.activeTimerColor : ConfigColors.textColor),
                            size: width(context) * 0.15,
                            shadows: applyShadow(),
                          ),
                        ),
                        GestureDetector(
                          onTap: _addTime,
                          child: Icon(
                            Icons.add_circle,
                            color: colorAddButton == true ? ConfigColors.activeTimerColor : ConfigColors.textColor,
                            size: width(context) * 0.15,
                            shadows: applyShadow(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
