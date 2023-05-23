import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/fonts.dart';
import 'package:white_noise/widgets/home_page.dart';

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
            fontFamilyFallback: ConfigFonts.fallBackFonts),
        home: const MyHomePage(title: 'Sleep Buddy'));
  }
}
