import 'package:flutter/material.dart';
import 'package:white_noise/config/colors.dart';
import 'package:white_noise/config/responsivity_tools.dart';

/// Get snackbar when device volume is too low
void getSnackBar(double volume, BuildContext context) {
  if (volume <= 0.1) {
    SnackBar snackBar = SnackBar(
      showCloseIcon: true,
      closeIconColor: ConfigColors.textColor,
      padding: const EdgeInsets.all(1),
      content: Text(
        'Volume is too low',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: width(context) * 0.05),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
