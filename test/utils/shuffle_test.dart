import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:memorymatch/models/card_model.dart';
import 'package:memorymatch/utils/shuffle.dart';

/// 16 cards (the Medium grid): ids 0 to 15, with two cards per pair ID.
List<MemoryCard> makeDeck() =>
    List.generate(16, (i) => MemoryCard(id: i, pairId: i ~/ 2));

void main() {
  group('shuffled', () {
    test('keeps every card exactly once', () {
      final deck = makeDeck();
      expect(shuffled(deck), unorderedEquals(deck));
    });

    test('returns a new list and leaves the original in order', () {
      final deck = makeDeck();
      final before = List<MemoryCard>.of(deck);
      final result = shuffled(deck);
      expect(identical(result, deck), isFalse);
      expect(deck, before);
    });

    test('changes the order', () {
      final deck = makeDeck();
      expect(shuffled(deck, seed: 42), isNot(deck));
    });

    test('gives the same order for the same seed', () {
      final deck = makeDeck();
      expect(shuffled(deck, seed: 7), shuffled(deck, seed: 7));
    });

    test('gives a different order for a different seed', () {
      final deck = makeDeck();
      expect(shuffled(deck, seed: 1), isNot(shuffled(deck, seed: 2)));
    });

    test('works on an empty list and a one-card list', () {
      expect(shuffled(<MemoryCard>[]), isEmpty);
      const one = MemoryCard(id: 0, pairId: 0);
      expect(shuffled([one]), [one]);
    });

    test('leaves the state of each card unchanged', () {
      const faceUp = MemoryCard(id: 0, pairId: 0, state: CardState.faceUp);
      const faceDown = MemoryCard(id: 1, pairId: 0);
      expect(shuffled([faceUp, faceDown]), unorderedEquals([faceUp, faceDown]));
    });
  });

  group('newSeed', () {
    test('is between 0 and maxSeed', () {
      for (var i = 0; i < 100; i++) {
        final seed = newSeed();
        expect(seed, greaterThanOrEqualTo(0));
        expect(seed, lessThan(maxSeed));
      }
    });

    test('is predictable when given a seeded Random', () {
      expect(newSeed(Random(5)), newSeed(Random(5)));
    });
  });
}
