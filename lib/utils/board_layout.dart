import 'dart:math' as math;
import 'dart:ui' show Size;

import '../models/grid_size.dart';

/// The shape of every card: 8 wide for every 11 tall. It matches the card
/// images (480 × 660 px), so they are never stretched or cropped.
const double cardAspectRatio = 8 / 11;

/// How big the cards and the whole grid should be on screen.
class BoardLayout {
  const BoardLayout({
    required this.cardWidth,
    required this.cardHeight,
    required this.gridWidth,
    required this.gridHeight,
  });

  final double cardWidth;
  final double cardHeight;

  /// The width of the whole grid: all the cards plus the gaps between them.
  final double gridWidth;

  /// The height of the whole grid: all the cards plus the gaps between them.
  final double gridHeight;
}

/// Works out the biggest cards that keep the [cardAspectRatio] and still fit
/// the whole [size] grid inside the [available] space.
///
/// The cards are limited by whichever runs out first, the width or the
/// height. So Hard (4 × 6) gets smaller cards than Easy (3 × 4) on the same
/// screen, and a short, wide screen gets smaller cards than a tall one.
///
/// [size] must be a valid grid (at least one column and one row). [spacing]
/// is the gap between cards, both across and down.
BoardLayout boardLayout(
    GridSize size,
    Size available, {
      double spacing = 8,
    }) {
  final columnGaps = spacing * (size.columns - 1);
  final rowGaps = spacing * (size.rows - 1);

  // The biggest card the width allows, and the biggest the height allows.
  final maxCardWidth = math.max(
    0.0,
    (available.width - columnGaps) / size.columns,
  );
  final maxCardHeight = math.max(
    0.0,
    (available.height - rowGaps) / size.rows,
  );

  // Use whichever is smaller, keeping the card shape.
  final cardWidth = math.min(maxCardWidth, maxCardHeight * cardAspectRatio);
  final cardHeight = cardWidth / cardAspectRatio;

  return BoardLayout(
    cardWidth: cardWidth,
    cardHeight: cardHeight,
    gridWidth: cardWidth * size.columns + columnGaps,
    gridHeight: cardHeight * size.rows + rowGaps,
  );
}