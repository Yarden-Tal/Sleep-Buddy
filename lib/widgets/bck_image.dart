import 'package:flutter/material.dart';
import 'package:white_noise/config/images.dart';

BoxDecoration backgroundImg(bool isDarkMode) => BoxDecoration(
        image: DecorationImage(
      image: isDarkMode ? Images.darkModeImg : Images.lightModeImg,
      fit: BoxFit.cover,
    ));
