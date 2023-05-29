/// Format each part of the computed time for the timer
String formatTimePart(int timePart) => timePart.toString().padLeft(2, '0');

String computeTime(int time) {
  String hours = formatTimePart(time ~/ 3600);
  String minutes = formatTimePart((time % 3600) ~/ 60);
  String seconds = formatTimePart(time % 60);
  return '$hours:$minutes:$seconds';
}
