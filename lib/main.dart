import 'package:flutter/material.dart';
// Libraries
import 'package:audioplayers/audioplayers.dart';
// Config
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/fonts.dart';
import 'package:white_noise/config/sounds.dart';
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
      title: 'Simple Night',
      theme: ThemeData(
        primaryColor: ConfigColors.primaryColor,
        fontFamily: ConfigFonts.primaryFont,
        fontFamilyFallback: ConfigFonts.fallBackFonts,
      ),
      home: const MyHomePage(
        title: 'Simple Night',
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
  bool _noiseIsOn = false;

  final player = AudioPlayer(playerId: "test");
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future setAudio() async {
    /// Loop the audio track
    await player.setReleaseMode(ReleaseMode.loop);
    const String url = Sound.rain;
    await player.setSourceAsset(url);
    isPlaying ? await player.pause() : await player.resume();
    isPlaying = !isPlaying;
  }

  void _toggleBtn() {
    setAudio();
    setState(() => _noiseIsOn = !_noiseIsOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ConfigColors.primaryColor,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PlayButton(noiseIsOn: _noiseIsOn, toggleButton: _toggleBtn),
          ],
        ),
      ),
      backgroundColor: ConfigColors.backgroundColor,
      persistentFooterButtons: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              // shape: const CircleBorder(),
              padding: const EdgeInsets.all(14),
              backgroundColor: ConfigColors.backgroundColor,
            ),
            onPressed: () {},
            child: const Icon(
              Icons.settings,
              size: 35,
            )),
      ],
    );
  }
}
