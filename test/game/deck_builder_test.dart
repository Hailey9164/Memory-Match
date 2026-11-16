import 'package:flutter_test/flutter_test.dart';

import 'package:memorymatch/game/deck_builder.dart';
import 'package:memorymatch/models/card_model.dart';
import 'package:memorymatch/models/grid_size.dart';

/// Counts how many cards have each pair ID.
Map<int, int> countByPairId(List<MemoryCard> deck) {
  final counts = <int, int>{};
  for (final card in deck) {
    counts[card.pairId] = (counts[card.pairId] ?? 0) + 1;
  }
  return counts;
}

void main() {
  group('GridSize', () {
    test('the three difficulty levels have the right sizes', () {
      expect(GridSize.easy.cardCount, 12);
      expect(GridSize.easy.pairCount, 6);
      expect(GridSize.medium.cardCount, 16);
      expect(GridSize.medium.pairCount, 8);
      expect(GridSize.hard.cardCount, 24);
      expect(GridSize.hard.pairCount, 12);
    });

    test('is valid only with an even number of cards', () {
      expect(GridSize.easy.isValid, isTrue);
      expect(const GridSize(3, 3).isValid, isFalse);
      expect(const GridSize(0, 4).isValid, isFalse);
      expect(const GridSize(4, -2).isValid, isFalse);
    });

    test('grids with the same columns and rows are equal', () {
      expect(const GridSize(4, 4), GridSize.medium);
      expect(const GridSize(4, 4).hashCode, GridSize.medium.hashCode);
      expect(GridSize.easy, isNot(GridSize.medium));
    });

    test('prints as columns × rows', () {
      expect(GridSize.hard.toString(), '4 × 6');
    });
  });

  group('buildDeck', () {
    final levels = {
      'Easy': GridSize.easy,
      'Medium': GridSize.medium,
      'Hard': GridSize.hard,
    };

    levels.forEach((name, size) {
      group(name, () {
        test('has one card for every spot in the grid', () {
          expect(buildDeck(size).length, size.cardCount);
        });

        test('has every pair ID exactly twice', () {
          final counts = countByPairId(buildDeck(size));
          expect(counts.keys.toSet(), {
            for (var i = 0; i < size.pairCount; i++) i,
          });
          expect(counts.values.every((count) => count == 2), isTrue);
        });

        test('gives each card an id equal to its position', () {
          final deck = buildDeck(size);
          for (var i = 0; i < deck.length; i++) {
            expect(deck[i].id, i);
          }
        });

        test('starts with every card face down', () {
          expect(buildDeck(size).every((card) => card.isFaceDown), isTrue);
        });

        test('shuffles the pairs instead of leaving them side by side', () {
          // Check a few seeds so one lucky ordering cannot fail the test.
          final shuffledCount = [1, 2, 3, 4, 5].where((seed) {
            final deck = buildDeck(size, seed: seed);
            for (var i = 0; i < deck.length; i += 2) {
              if (deck[i].pairId != deck[i + 1].pairId) return true;
            }
            return false;
          }).length;
          expect(shuffledCount, 5);
        });
      });
    });

    test('gives the same deck for the same seed', () {
      expect(
        buildDeck(GridSize.medium, seed: 99),
        buildDeck(GridSize.medium, seed: 99),
      );
    });

    test('gives a different deck for a different seed', () {
      expect(
        buildDeck(GridSize.medium, seed: 1),
        isNot(buildDeck(GridSize.medium, seed: 2)),
      );
    });

    test('every card has exactly one partner that matches it', () {
      final deck = buildDeck(GridSize.hard, seed: 3);
      for (final card in deck) {
        final partners = deck.where(card.matches).toList();
        expect(partners.length, 1);
      }
    });

    test('throws for a grid with an odd number of cards', () {
      expect(() => buildDeck(const GridSize(3, 3)), throwsArgumentError);
    });

    test('throws for a grid with no cards', () {
      expect(() => buildDeck(const GridSize(0, 4)), throwsArgumentError);
    });
  });
}
