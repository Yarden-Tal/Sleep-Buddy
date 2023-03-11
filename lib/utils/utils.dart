import 'package:white_noise/config/sounds.dart';

/// Changes the url [String] var by the chosen sound
String setUrlBySound(String sound) {
  String url = "";
  if (sound == SoundsEnum.waves.name) {
    url = Sound.waves;
  } else if (sound == SoundsEnum.rain.name) {
    url = Sound.rain;
  } else if (sound == SoundsEnum.generic.name) {
    url = Sound.generic;
  } else if (sound == SoundsEnum.forest.name) {
    url = Sound.forest;
  }
  return url;
}
