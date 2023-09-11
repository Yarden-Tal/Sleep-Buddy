/// Capitalizes & removes file-name, file-type
String formatSoundName(String sound) {
  String cleanSoundName = sound.replaceAll("audio/", "").replaceAll(".mp3", "").replaceAll(".flac", "").replaceAll("-", " ");
  String firstLetter = cleanSoundName[0].toUpperCase();
  String restOfWord = cleanSoundName.substring(1);
  String capitalizedSoundName = "$firstLetter$restOfWord";
  return capitalizedSoundName;
}
