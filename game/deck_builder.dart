import '../models/card_model.dart';
import '../models/grid_size.dart';
import '../utils/shuffle.dart';

/// Builds a shuffled deck of face-down cards that fills [size].
///
/// - The deck has `size.pairCount` pairs, so every card has exactly one
///   partner. Pair IDs run from 0 to `pairCount - 1`.
/// - Each card's `id` is its position in the returned list, which is its
///   position on the board (left to right, then top to bottom). So
///   `deck[i].id == i`.
/// - Every card starts face down.
/// - With a [seed], the same seed gives the same deck, so a board can be
///   replayed. Without one, the deck is different every time.
///
/// Throws an [ArgumentError] if [size] has no cards or an odd number of
/// cards, because then one card could never be matched.
List<MemoryCard> buildDeck(GridSize size, {int? seed}) {
  if (!size.isValid) {
    throw ArgumentError.value(
      size,
      'size',
      'A grid needs at least one card and an even number of cards.',
    );
  }

  // Two copies of every pair ID: 0, 0, 1, 1, 2, 2, ...
  final pairIds = <int>[
    for (var pairId = 0; pairId < size.pairCount; pairId++) ...[pairId, pairId],
  ];

  // Shuffle the pair IDs, then deal one card per position.
  final shuffledPairIds = shuffled(pairIds, seed: seed);
  return List.generate(
    shuffledPairIds.length,
    (position) => MemoryCard(id: position, pairId: shuffledPairIds[position]),
  );
}
