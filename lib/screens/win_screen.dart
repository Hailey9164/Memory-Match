import 'package:flutter/material.dart';

import '../game/score.dart';
import '../models/grid_size.dart';
import '../utils/format_time.dart';
import 'game_screen.dart';

/// Shown when every pair has been matched: the time, the moves, and the score,
/// with buttons to play again or pick a different difficulty.
class WinScreen extends StatelessWidget {
  const WinScreen({
    super.key,
    required this.gridSize,
    required this.seconds,
    required this.moves,
  });

  /// The difficulty that was just played.
  final GridSize gridSize;

  /// The final time of the round.
  final int seconds;

  /// The final move count of the round.
  final int moves;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final score = calculateScore(seconds: seconds, size: gridSize);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You won!',
                    style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(difficultyName(gridSize), style: textTheme.titleMedium),

                  const SizedBox(height: 32),

                  Text('Score', style: textTheme.labelLarge),
                  Text(
                    '$score',
                    style: textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _Result(
                          label: 'Time',
                          value: formatTime(seconds),
                        ),
                      ),
                      Expanded(
                        child: _Result(label: 'Moves', value: '$moves'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Play again starts a new shuffled board on the same
                  // difficulty. It replaces this screen, so Back from the new
                  // board still goes to the menu.
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => GameScreen(gridSize: gridSize),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Play again'),
                  ),

                  const SizedBox(height: 12),

                  // This screen replaced the board, so going back lands on the
                  // difficulty menu.
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Change difficulty'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One label with its number underneath.
class _Result extends StatelessWidget {
  const _Result({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(label, style: textTheme.labelLarge),
        Text(
          value,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}