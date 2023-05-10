import 'package:flutter/material.dart';
// Libraries
import 'package:audioplayers/audioplayers.dart';
import 'package:volume_controller/volume_controller.dart';
// Config
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/fonts.dart';
import 'package:white_noise/config/sounds.dart';
import 'package:white_noise/settings_bottom_sheet.dart';
// Widgets
import 'package:white_noise/widgets/play_button.dart';
import 'package:white_noise/widgets/timer.dart';

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
    isPlaying = !isPlaying;
  }

  void handleVolumeChange(double value) {
    VolumeController().setVolume(_volumeListenerValue);
    setState(() {
      _volumeListenerValue = value;
    });
  }

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
              const TimerWidget(),
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
