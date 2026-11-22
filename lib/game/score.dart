import '../models/grid_size.dart';

/// What a round is worth if it is finished instantly, before the difficulty
/// multiplier is applied.
const int maxScore = 1000;

/// Points lost for every second the round takes.
const int pointsLostPerSecond = 5;

/// The lowest a round can score before the multiplier, so finishing a round
/// always earns something, however slow it was. (It is reached at 180 seconds.)
const int minScore = 100;

/// How much a round on [size] is multiplied by. Bigger boards take longer, so
/// they are worth more: Easy x1, Medium x1.5, Hard x2.
/// A grid that is not one of the three difficulties uses x1.
double difficultyMultiplier(GridSize size) {
  if (size == GridSize.hard) return 2.0;
  if (size == GridSize.medium) return 1.5;
  return 1.0;
}

/// The name of the difficulty for [size], for showing on screen.
String difficultyName(GridSize size) {
  if (size == GridSize.easy) return 'Easy';
  if (size == GridSize.medium) return 'Medium';
  if (size == GridSize.hard) return 'Hard';
  return size.toString();
}

/// The score for finishing a round on [size] in [seconds].
///
///     base  = 1000 - 5 x seconds       (never below 100)
///     score = base x difficulty multiplier, rounded
///
/// A faster time always scores higher, until the base reaches its minimum.
/// The time is the only thing that sets the score; the move count is shown on
/// the win screen but is not part of the score.
int calculateScore({required int seconds, required GridSize size}) {
  final time = seconds < 0 ? 0 : seconds;
  final base = (maxScore - pointsLostPerSecond * time).clamp(
    minScore,
    maxScore,
  );
  return (base * difficultyMultiplier(size)).round();
}