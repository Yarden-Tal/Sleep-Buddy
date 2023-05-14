// import 'package:white_noise/config/sounds.dart';

/// Capitalizes & removes file-name and file-type
String formatSoundName(String sound) {
  String cleanSoundName = sound.replaceAll("audio/", "").replaceAll(".mp3", "");
  String firstLetter = cleanSoundName[0].toUpperCase();
  String restOfWord = cleanSoundName.substring(1);
  String capitalizedSoundName = "$firstLetter$restOfWord";
  return capitalizedSoundName;
}

/// Changes the url [String] var by the chosen sound
// String setUrlBySound(String sound) {
//   String url = "";
//   if (sound == SoundsEnum.waves.name) {
//     url = Sound.waves;
//   } else if (sound == SoundsEnum.rain.name) {
//     url = Sound.rain;
//   } else if (sound == SoundsEnum.generic.name) {
//     url = Sound.generic;
//   } else if (sound == SoundsEnum.forest.name) {
//     url = Sound.forest;
//   }
//   return url;
// }
