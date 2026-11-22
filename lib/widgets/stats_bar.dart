import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import '../utils/format_time.dart';

/// The row at the top of the board that shows the time and the move count.
class StatsBar extends StatelessWidget {
  const StatsBar({super.key, required this.seconds, required this.moves});

  /// Seconds played so far, shown as minutes and seconds.
  final int seconds;

  /// Moves made so far. Two flips make one move.
  final int moves;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Stat(label: 'Time', value: formatTime(seconds))),
        Expanded(child: _Stat(label: 'Moves', value: '$moves')),
      ],
    );
  }
}

/// One label with its number underneath, such as "Time" over "1:05".
class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(label, style: textTheme.labelMedium),
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            // Every digit is the same width, so the numbers do not jiggle.
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}