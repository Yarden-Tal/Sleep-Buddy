/// Capitalizes & removes file-name and file-type
String formatSoundName(String sound) {
  String cleanSoundName = sound.replaceAll("audio/", "").replaceAll(".mp3", "").replaceAll("-", " ");
  String firstLetter = cleanSoundName[0].toUpperCase();
  String restOfWord = cleanSoundName.substring(1);
  String capitalizedSoundName = "$firstLetter$restOfWord";
  return capitalizedSoundName;
}
