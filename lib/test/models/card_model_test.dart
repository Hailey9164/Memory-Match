import 'package:flutter_test/flutter_test.dart';

// Replace "memory_match" with the name field in your pubspec.yaml.
import 'package:memorymatch/models/card_model.dart';

void main() {
  group('MemoryCard', () {
    test('starts face down', () {
      const card = MemoryCard(id: 0, pairId: 3);
      expect(card.state, CardState.faceDown);
      expect(card.isFaceDown, isTrue);
      expect(card.isFaceUp, isFalse);
      expect(card.isMatched, isFalse);
    });

    test('keeps its id and pair ID when its state changes', () {
      const card = MemoryCard(id: 5, pairId: 2);
      final flipped = card.flipUp();
      expect(flipped.id, 5);
      expect(flipped.pairId, 2);
    });

    group('flipUp', () {
      test('turns a face-down card face up', () {
        const card = MemoryCard(id: 0, pairId: 0);
        expect(card.flipUp().state, CardState.faceUp);
      });

      test('does nothing to a face-up card', () {
        const card = MemoryCard(id: 0, pairId: 0, state: CardState.faceUp);
        expect(card.flipUp(), card);
      });

      test('does nothing to a matched card', () {
        const card = MemoryCard(id: 0, pairId: 0, state: CardState.matched);
        expect(card.flipUp(), card);
      });
    });

    group('flipDown', () {
      test('turns a face-up card face down', () {
        const card = MemoryCard(id: 0, pairId: 0, state: CardState.faceUp);
        expect(card.flipDown().state, CardState.faceDown);
      });

      test('does nothing to a face-down card', () {
        const card = MemoryCard(id: 0, pairId: 0);
        expect(card.flipDown(), card);
      });

      test('does nothing to a matched card', () {
        const card = MemoryCard(id: 0, pairId: 0, state: CardState.matched);
        expect(card.flipDown(), card);
      });
    });

    group('markMatched', () {
      test('turns a face-up card into a matched card', () {
        const card = MemoryCard(id: 0, pairId: 0, state: CardState.faceUp);
        expect(card.markMatched().state, CardState.matched);
      });

      test('does nothing to a face-down card', () {
        const card = MemoryCard(id: 0, pairId: 0);
        expect(card.markMatched(), card);
      });

      test('does nothing to a matched card', () {
        const card = MemoryCard(id: 0, pairId: 0, state: CardState.matched);
        expect(card.markMatched(), card);
      });
    });

    group('matches', () {
      test('is true for two different cards with the same pair ID', () {
        const a = MemoryCard(id: 0, pairId: 4);
        const b = MemoryCard(id: 9, pairId: 4);
        expect(a.matches(b), isTrue);
        expect(b.matches(a), isTrue);
      });

      test('is false for cards with different pair IDs', () {
        const a = MemoryCard(id: 0, pairId: 4);
        const b = MemoryCard(id: 1, pairId: 5);
        expect(a.matches(b), isFalse);
      });

      test('is false for a card compared with itself', () {
        const a = MemoryCard(id: 0, pairId: 4);
        expect(a.matches(a), isFalse);
      });

      test('ignores the state of the cards', () {
        const a = MemoryCard(id: 0, pairId: 4, state: CardState.faceUp);
        const b = MemoryCard(id: 1, pairId: 4);
        expect(a.matches(b), isTrue);
      });
    });

    test('cards with the same id, pair ID, and state are equal', () {
      const a = MemoryCard(id: 1, pairId: 2);
      const b = MemoryCard(id: 1, pairId: 2);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a.flipUp(), isNot(b));
    });
  });
}
