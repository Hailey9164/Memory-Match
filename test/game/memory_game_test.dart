import 'package:flutter_test/flutter_test.dart';
import 'package:memorymatch/game/memory_game.dart';
import 'package:memorymatch/models/grid_size.dart';

/// A short pause, so the tests do not have to wait long for cards to flip back.
const mismatchDelay = Duration(milliseconds: 20);

/// Waits long enough for a mismatched pair to flip back.
Future<void> waitForFlipBack() =>
    Future<void>.delayed(const Duration(milliseconds: 100));

/// Finds the ids of two face-down cards that are a pair ([matching] true) or
/// are not a pair ([matching] false). This keeps the tests from depending on
/// how a particular seed happens to shuffle.
List<int> findPair(MemoryGame game, {required bool matching}) {
  final faceDown = [
    for (final card in game.cards)
      if (card.isFaceDown) card,
  ];
  for (var i = 0; i < faceDown.length; i++) {
    for (var j = i + 1; j < faceDown.length; j++) {
      if (faceDown[i].matches(faceDown[j]) == matching) {
        return [faceDown[i].id, faceDown[j].id];
      }
    }
  }
  throw StateError('No such pair on the board.');
}

/// The id of a card that is not in [ids].
int otherCard(List<int> ids) {
  for (var id = 0; ; id++) {
    if (!ids.contains(id)) return id;
  }
}

/// Flips both cards of every pair, so the whole board ends up matched.
void matchEverything(MemoryGame game) {
  final idsByPair = <int, List<int>>{};
  for (final card in game.cards) {
    idsByPair.putIfAbsent(card.pairId, () => []).add(card.id);
  }
  for (final ids in idsByPair.values) {
    game.flip(ids[0]);
    game.flip(ids[1]);
  }
}

void main() {
  group('MemoryGame', () {
    late MemoryGame game;

    setUp(() {
      game = MemoryGame(
        GridSize.medium,
        seed: 1,
        mismatchDelay: mismatchDelay,
      );
    });

    tearDown(() {
      game.dispose();
    });

    group('the board', () {
      test('starts with a full board and every card face down', () {
        expect(game.cards.length, GridSize.medium.cardCount);
        expect(game.cards.every((card) => card.isFaceDown), isTrue);
        expect(game.faceUpCards, isEmpty);
        expect(game.hasTwoFaceUp, isFalse);
      });

      test('deals the same board for the same seed', () {
        final other = MemoryGame(GridSize.medium, seed: 1);
        addTearDown(other.dispose);
        expect(other.cards, game.cards);
      });

      test('cannot be changed through the cards list', () {
        expect(() => game.cards.clear(), throwsUnsupportedError);
      });
    });

    group('flipping one card', () {
      test('turns a face-down card face up and returns true', () {
        expect(game.flip(3), isTrue);
        expect(game.cards[3].isFaceUp, isTrue);
      });

      test('leaves every other card face down', () {
        game.flip(3);
        for (var i = 0; i < game.cards.length; i++) {
          if (i != 3) expect(game.cards[i].isFaceDown, isTrue);
        }
      });

      test('ignores a tap on a card that is already face up', () {
        game.flip(3);
        expect(game.flip(3), isFalse);
        expect(game.cards[3].isFaceUp, isTrue);
        expect(game.faceUpCards.length, 1);
      });

      test('ignores an id that is not on the board', () {
        expect(game.flip(-1), isFalse);
        expect(game.flip(GridSize.medium.cardCount), isFalse);
        expect(game.faceUpCards, isEmpty);
      });
    });

    group('a matching pair', () {
      test('both cards become matched', () {
        final pair = findPair(game, matching: true);
        expect(game.flip(pair[0]), isTrue);
        expect(game.flip(pair[1]), isTrue);
        expect(game.cards[pair[0]].isMatched, isTrue);
        expect(game.cards[pair[1]].isMatched, isTrue);
      });

      test('no cards are left face up, so the next tap works', () {
        final pair = findPair(game, matching: true);
        game.flip(pair[0]);
        game.flip(pair[1]);
        expect(game.faceUpCards, isEmpty);
        expect(game.hasTwoFaceUp, isFalse);
        expect(game.flip(otherCard(pair)), isTrue);
      });

      test('stays matched after waiting', () async {
        final pair = findPair(game, matching: true);
        game.flip(pair[0]);
        game.flip(pair[1]);
        await waitForFlipBack();
        expect(game.cards[pair[0]].isMatched, isTrue);
        expect(game.cards[pair[1]].isMatched, isTrue);
      });

      test('cannot be flipped again', () {
        final pair = findPair(game, matching: true);
        game.flip(pair[0]);
        game.flip(pair[1]);
        expect(game.flip(pair[0]), isFalse);
        expect(game.cards[pair[0]].isMatched, isTrue);
      });

      test('only changes the two cards of the pair', () {
        final pair = findPair(game, matching: true);
        game.flip(pair[0]);
        game.flip(pair[1]);
        for (var i = 0; i < game.cards.length; i++) {
          if (!pair.contains(i)) expect(game.cards[i].isFaceDown, isTrue);
        }
      });
    });

    group('a mismatched pair', () {
      test('stays face up right after the second flip', () {
        final pair = findPair(game, matching: false);
        game.flip(pair[0]);
        game.flip(pair[1]);
        expect(game.cards[pair[0]].isFaceUp, isTrue);
        expect(game.cards[pair[1]].isFaceUp, isTrue);
        expect(game.hasTwoFaceUp, isTrue);
      });

      test('locks the board: a third card cannot be flipped', () {
        final pair = findPair(game, matching: false);
        game.flip(pair[0]);
        game.flip(pair[1]);
        final third = otherCard(pair);
        expect(game.canFlip(third), isFalse);
        expect(game.flip(third), isFalse);
        expect(game.cards[third].isFaceDown, isTrue);
      });

      test('flips back down after the pause', () async {
        final pair = findPair(game, matching: false);
        game.flip(pair[0]);
        game.flip(pair[1]);
        await waitForFlipBack();
        expect(game.cards[pair[0]].isFaceDown, isTrue);
        expect(game.cards[pair[1]].isFaceDown, isTrue);
        expect(game.faceUpCards, isEmpty);
      });

      test('unlocks the board after the pause', () async {
        final pair = findPair(game, matching: false);
        game.flip(pair[0]);
        game.flip(pair[1]);
        await waitForFlipBack();
        expect(game.flip(otherCard(pair)), isTrue);
      });

      test('does not flip back cards that were already matched', () async {
        final match = findPair(game, matching: true);
        game.flip(match[0]);
        game.flip(match[1]);

        final miss = findPair(game, matching: false);
        game.flip(miss[0]);
        game.flip(miss[1]);
        await waitForFlipBack();

        expect(game.cards[match[0]].isMatched, isTrue);
        expect(game.cards[match[1]].isMatched, isTrue);
        expect(game.cards[miss[0]].isFaceDown, isTrue);
        expect(game.cards[miss[1]].isFaceDown, isTrue);
      });

      test('can be tried again after flipping back', () async {
        final pair = findPair(game, matching: false);
        game.flip(pair[0]);
        game.flip(pair[1]);
        await waitForFlipBack();
        expect(game.flip(pair[0]), isTrue);
        expect(game.cards[pair[0]].isFaceUp, isTrue);
      });
    });

    group('the move counter', () {
      test('starts at zero', () {
        expect(game.moves, 0);
      });

      test('does not count the first card of a turn', () {
        game.flip(3);
        expect(game.moves, 0);
      });

      test('counts a mismatched pair as one move', () {
        final pair = findPair(game, matching: false);
        game.flip(pair[0]);
        game.flip(pair[1]);
        expect(game.moves, 1);
      });

      test('counts a matching pair as one move', () {
        final pair = findPair(game, matching: true);
        game.flip(pair[0]);
        game.flip(pair[1]);
        expect(game.moves, 1);
      });

      test('does not count taps that are ignored', () {
        final pair = findPair(game, matching: false);
        game.flip(pair[0]);
        game.flip(pair[0]); // already face up
        game.flip(-1); // not on the board
        expect(game.moves, 0);

        game.flip(pair[1]);
        game.flip(otherCard(pair)); // board is locked
        game.flip(pair[0]); // board is locked
        expect(game.moves, 1);
      });

      test('does not count the flip back as a move', () async {
        final pair = findPair(game, matching: false);
        game.flip(pair[0]);
        game.flip(pair[1]);
        await waitForFlipBack();
        expect(game.moves, 1);
      });

      test('keeps counting across turns', () async {
        final miss = findPair(game, matching: false);
        game.flip(miss[0]);
        game.flip(miss[1]);
        await waitForFlipBack();

        final match = findPair(game, matching: true);
        game.flip(match[0]);
        game.flip(match[1]);
        expect(game.moves, 2);
      });

      test('is already updated when listeners hear about the second flip', () {
        var movesWhenNotified = -1;
        game.addListener(() => movesWhenNotified = game.moves);

        final pair = findPair(game, matching: true);
        game.flip(pair[0]);
        game.flip(pair[1]);
        expect(movesWhenNotified, 1);
      });
    });

    group('pairs found', () {
      test('starts at zero', () {
        expect(game.pairsFound, 0);
      });

      test('goes up by one for each matched pair', () {
        final first = findPair(game, matching: true);
        game.flip(first[0]);
        game.flip(first[1]);
        expect(game.pairsFound, 1);

        final second = findPair(game, matching: true);
        game.flip(second[0]);
        game.flip(second[1]);
        expect(game.pairsFound, 2);
      });

      test('does not go up for a mismatch', () {
        final pair = findPair(game, matching: false);
        game.flip(pair[0]);
        game.flip(pair[1]);
        expect(game.pairsFound, 0);
      });
    });

    group('winning', () {
      test('is not won at the start', () {
        expect(game.isWon, isFalse);
      });

      test('is not won while pairs are still missing', () {
        final pair = findPair(game, matching: true);
        game.flip(pair[0]);
        game.flip(pair[1]);
        expect(game.isWon, isFalse);
      });

      test('is won when every pair is matched', () {
        matchEverything(game);
        expect(game.isWon, isTrue);
        expect(game.pairsFound, GridSize.medium.pairCount);
        expect(game.faceUpCards, isEmpty);
      });

      test('takes one move per pair when there are no mistakes', () {
        matchEverything(game);
        expect(game.moves, GridSize.medium.pairCount);
      });

      test('works on every difficulty', () {
        for (final size in [GridSize.easy, GridSize.medium, GridSize.hard]) {
          final other = MemoryGame(size, seed: 3);
          addTearDown(other.dispose);
          matchEverything(other);
          expect(other.isWon, isTrue, reason: 'size $size');
          expect(other.moves, size.pairCount, reason: 'size $size');
        }
      });

      test('ignores every tap once the round is won', () {
        matchEverything(game);
        for (var i = 0; i < game.cards.length; i++) {
          expect(game.flip(i), isFalse);
        }
        expect(game.moves, GridSize.medium.pairCount);
      });

      test('is already true when listeners hear about the last match', () {
        var wonWhenNotified = false;
        game.addListener(() => wonWhenNotified = game.isWon);
        matchEverything(game);
        expect(wonWhenNotified, isTrue);
      });
    });

    group('listeners', () {
      test('are told for each flip and once more when cards flip back',
          () async {
        var calls = 0;
        game.addListener(() => calls++);

        final pair = findPair(game, matching: false);
        game.flip(pair[0]); // first card: 1
        game.flip(pair[1]); // second card: 2
        game.flip(pair[0]); // ignored: no notification
        expect(calls, 2);

        await waitForFlipBack();
        expect(calls, 3); // the pair flipped back
      });

      test('are told once when a matching pair is found', () {
        var calls = 0;
        game.addListener(() => calls++);

        final pair = findPair(game, matching: true);
        game.flip(pair[0]);
        game.flip(pair[1]);
        expect(calls, 2);
      });
    });

    test('disposing the game cancels a pending flip-back', () async {
      final other = MemoryGame(
        GridSize.medium,
        seed: 1,
        mismatchDelay: mismatchDelay,
      );
      final pair = findPair(other, matching: false);
      other.flip(pair[0]);
      other.flip(pair[1]);
      other.dispose();

      // If the flip-back still ran, it would notify a disposed game and the
      // test would fail with an error.
      await waitForFlipBack();
    });
  });
}
