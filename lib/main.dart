import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'White Noise',
      theme: ThemeData(
        primaryColor: ConfigColors.primaryColor,
      ),
      home: const MyHomePage(
        title: 'White Noise app',
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

  void _toggleBtn() {
    setState(() {
      _noiseIsOn = !_noiseIsOn;
    });
  }

  Widget _createButton() {
    double iconSize = 85;
    return _noiseIsOn
        ? Icon(Icons.stop_rounded, size: iconSize)
        : Icon(
            Icons.play_arrow_rounded,
            size: iconSize,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConfigColors.primaryColor,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(24),
                  backgroundColor: ConfigColors.primaryColor,
                ),
                onPressed: () => _toggleBtn(),
                child: _createButton()),
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
            onPressed: () => _toggleBtn(),
            child: const Icon(
              Icons.settings,
              size: 35,
            )),
      ],
    );
  }
}
