import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:white_noise/config/fonts.dart';
import 'package:white_noise/widgets/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Sleep Buddy',
      theme: ThemeData(fontFamily: ConfigFonts.primaryFont, fontFamilyFallback: ConfigFonts.fallBackFonts),
      home: const MyHomePage(title: 'Sleep Buddy'));
}
