import 'package:flutter/material.dart';

import '../models/grid_size.dart';

/// One big button on the menu: a mini picture of the grid, the difficulty
/// name, and the grid size with its pair count, such as "4 × 4 · 8 pairs".
class DifficultyButton extends StatelessWidget {
  const DifficultyButton({
    super.key,
    required this.label,
    required this.size,
    required this.onPressed,
  });

  /// The difficulty name, such as "Easy".
  final String label;

  /// The grid this difficulty plays on.
  final GridSize size;

  /// Called when the button is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        // Full width and 124 tall, so it is easy to tap.
        minimumSize: const Size.fromHeight(124),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(width: 2, color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          // The mini grid is only a picture, so screen readers skip it.
          ExcludeSemantics(
            child: SizedBox(width: 64, child: Center(child: _MiniGrid(size))),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${size.columns} × ${size.rows} · ${size.pairCount} pairs',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A small picture of the grid: one little rounded rectangle per card.
class _MiniGrid extends StatelessWidget {
  const _MiniGrid(this.size);

  final GridSize size;

  static const double _cellWidth = 10;
  static const double _cellHeight = 13;
  static const double _gap = 3;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < size.rows; row++) ...[
          if (row > 0) const SizedBox(height: _gap),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var column = 0; column < size.columns; column++) ...[
                if (column > 0) const SizedBox(width: _gap),
                Container(
                  width: _cellWidth,
                  height: _cellHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}