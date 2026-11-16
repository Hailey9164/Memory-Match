/// The three states a card can be in.
enum CardState {
  /// Back showing. The player has not flipped it, or it flipped back after a miss.
  faceDown,

  /// Front showing. The player just flipped it and it has not been checked yet.
  faceUp,

  /// Part of a pair that was found. It stays face up for the rest of the round.
  matched,
}

/// One card on the board.
///
/// A card is immutable: to change its state, call [flipUp], [flipDown], or
/// [markMatched], which return a new card.
class MemoryCard {
  const MemoryCard({
    required this.id,
    required this.pairId,
    this.state = CardState.faceDown,
  });

  /// Unique for every card on the board (0 to number of cards - 1).
  ///
  /// It tells the two cards of a pair apart, so the game can ignore a second
  /// tap on the same card instead of treating it as a match.
  final int id;

  /// Shared by the two cards of a pair (0 to number of pairs - 1).
  ///
  /// It also picks the picture to draw, for example the card image for this
  /// pair in the current theme.
  final int pairId;

  /// Whether the card is face down, face up, or matched.
  final CardState state;

  bool get isFaceDown => state == CardState.faceDown;
  bool get isFaceUp => state == CardState.faceUp;
  bool get isMatched => state == CardState.matched;

  /// Returns a copy of this card with the given fields replaced.
  MemoryCard copyWith({CardState? state}) {
    return MemoryCard(id: id, pairId: pairId, state: state ?? this.state);
  }

  /// Face down to face up. A card in any other state is returned unchanged,
  /// so a face-up or matched card cannot be flipped again by a tap.
  MemoryCard flipUp() => isFaceDown ? copyWith(state: CardState.faceUp) : this;

  /// Face up to face down, used when two flipped cards do not match.
  /// A card in any other state is returned unchanged, so a matched card can
  /// never be flipped back.
  MemoryCard flipDown() => isFaceUp ? copyWith(state: CardState.faceDown) : this;

  /// Face up to matched, used when two flipped cards are a pair.
  /// A card in any other state is returned unchanged.
  MemoryCard markMatched() =>
      isFaceUp ? copyWith(state: CardState.matched) : this;

  /// True when [other] is the other card of this card's pair.
  ///
  /// A card never matches itself, even though its pair ID is the same.
  bool matches(MemoryCard other) => id != other.id && pairId == other.pairId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryCard &&
          other.id == id &&
          other.pairId == pairId &&
          other.state == state;

  @override
  int get hashCode => Object.hash(id, pairId, state);

  @override
  String toString() => 'MemoryCard(id: $id, pairId: $pairId, state: $state)';
}
