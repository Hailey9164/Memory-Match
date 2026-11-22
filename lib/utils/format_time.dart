/// Turns a number of seconds into minutes and seconds, like `0:07` or `12:05`.
///
/// The seconds are always two digits. Minutes keep counting past 59 (so 3600
/// seconds is `60:00`), because a round should never take that long anyway.
/// A negative number is shown as `0:00`.
String formatTime(int totalSeconds) {
  if (totalSeconds < 0) totalSeconds = 0;
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}