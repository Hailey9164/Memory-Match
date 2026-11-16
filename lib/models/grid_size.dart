/// The size of the card grid: how many columns and rows of cards.
///
/// Cards are laid out left to right, then top to bottom, so card number
/// `row * columns + column` sits at that row and column.
class GridSize {
  const GridSize(this.columns, this.rows);

  /// 3 columns × 4 rows: 12 cards, 6 pairs.
  static const GridSize easy = GridSize(3, 4);

  /// 4 columns × 4 rows: 16 cards, 8 pairs.
  static const GridSize medium = GridSize(4, 4);

  /// 4 columns × 6 rows: 24 cards, 12 pairs.
  static const GridSize hard = GridSize(4, 6);

  final int columns;
  final int rows;

  /// How many cards fill the grid.
  int get cardCount => columns * rows;

  /// How many pairs fill the grid.
  int get pairCount => cardCount ~/ 2;

  /// True when the grid has at least one card and an even number of cards,
  /// so every card has a partner.
  bool get isValid => columns > 0 && rows > 0 && cardCount.isEven;

  @override
  bool operator ==(Object other) =>
      other is GridSize && other.columns == columns && other.rows == rows;

  @override
  int get hashCode => Object.hash(columns, rows);

  @override
  String toString() => '$columns × $rows';
}
