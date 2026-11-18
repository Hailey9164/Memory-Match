import 'dart:math';

/// The largest seed value. Taken from `KlondikeGame.maxInt` in the Klondike
/// game, which is (2 to the power 32) - 2.
const int maxSeed = 0xFFFFFFFE;

/// Returns a new random seed, the same way Klondike's `deal()` makes one.
///
/// Pass your own [random] only in tests, so the seed is predictable.
int newSeed([Random? random]) => (random ?? Random()).nextInt(maxSeed);

/// Returns a shuffled copy of [items]. The original list is not changed.
List<T> shuffled<T>(List<T> items, {int? seed}) {
  final copy = List<T>.of(items);
  copy.shuffle(seed == null ? Random() : Random(seed));
  return copy;
}
