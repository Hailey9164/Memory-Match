import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/card_model.dart';
import '../models/grid_size.dart';
import 'deck_builder.dart';

/// The state of one round: the board of cards and the rules for flipping and
/// matching them.
///
/// It extends [ChangeNotifier], so a screen can listen to it and rebuild
/// whenever a card, the move count, or the win state changes.
class MemoryGame extends ChangeNotifier {
  /// Deals a new round for [size]. With a [seed], the same seed deals the
  /// same board (see `buildDeck`).
  ///
  /// [mismatchDelay] is how long two cards that do not match stay face up
  /// before they flip back, so the player has time to see them.
  MemoryGame(
    this.size, {
    int? seed,
    this.mismatchDelay = const Duration(milliseconds: 800),
  }) : _cards = buildDeck(size, seed: seed);

  final GridSize size;
  final Duration mismatchDelay;
  final List<MemoryCard> _cards;

  /// Set while two cards that do not match are waiting to flip back.
  Timer? _mismatchTimer;

  int _moves = 0;

  /// Every card on the board, in board order (left to right, then top to
  /// bottom). The list cannot be changed: use [flip] to change a card.
  List<MemoryCard> get cards => List.unmodifiable(_cards);

  /// The cards that are face up and not yet matched. Matched cards are not
  /// included, because they are finished.
  List<MemoryCard> get faceUpCards => [
    for (final card in _cards)
      if (card.isFaceUp) card,
  ];

  /// True when two cards that do not match are face up, waiting to flip back.
  /// Two cards that do match are turned into matched cards straight away, so
  /// this is only true during the short pause after a mismatch.
  bool get hasTwoFaceUp => faceUpCards.length == 2;

  /// How many moves the player has made. Flipping two cards is one move, and
  /// it counts when the second card is flipped, whether or not they match.
  /// Taps that are ignored do not count.
  int get moves => _moves;

  /// How many pairs have been matched so far. Compare it with
  /// `size.pairCount` for a progress line such as "1 of 8 pairs found".
  int get pairsFound => _cards.where((card) => card.isMatched).length ~/ 2;

  /// True when every pair has been matched, so the round is over. Use it to
  /// stop the timer and show the win screen.
  bool get isWon => _cards.every((card) => card.isMatched);

  /// Whether a tap on the card with this [id] should flip it.
  ///
  /// A card can be flipped only when all of these are true:
  /// - the [id] is on the board,
  /// - two cards are not already waiting to flip back (this is what locks the
  ///   board during the pause after a mismatch),
  /// - the card itself is face down (so a face-up or matched card is ignored).
  ///
  /// When the round is won, every card is matched, so nothing can be flipped.
  bool canFlip(int id) =>
      id >= 0 && id < _cards.length && !hasTwoFaceUp && _cards[id].isFaceDown;

  /// Flips the card with this [id] face up, if [canFlip] allows it.
  ///
  /// When this is the second card of a turn, the move count goes up by one
  /// and the two cards are checked straight away:
  /// - a matching pair becomes matched and stays face up for the rest of the
  ///   round;
  /// - a mismatched pair stays face up for [mismatchDelay], then flips back.
  ///
  /// Returns true if the card was flipped, and false if the tap was ignored.
  /// Listeners are told once for each card that really flips, and once more
  /// when a mismatched pair flips back.
  bool flip(int id) {
    if (!canFlip(id)) return false;
    _cards[id] = _cards[id].flipUp();
    if (hasTwoFaceUp) {
      _checkPair();
    }
    notifyListeners();
    return true;
  }

  /// Counts the move and checks the two face-up cards. Called only when
  /// exactly two are face up.
  void _checkPair() {
    _moves++;
    final first = faceUpCards[0];
    final second = faceUpCards[1];
    if (first.matches(second)) {
      _cards[first.id] = first.markMatched();
      _cards[second.id] = second.markMatched();
    } else {
      _mismatchTimer = Timer(mismatchDelay, _flipMismatchBack);
    }
  }

  /// Turns the two mismatched cards face down again.
  void _flipMismatchBack() {
    _mismatchTimer = null;
    for (final card in faceUpCards) {
      _cards[card.id] = card.flipDown();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // Stop a pending flip-back, so it cannot touch the game after it is gone.
    _mismatchTimer?.cancel();
    super.dispose();
  }
}
