import 'package:flutter/material.dart';

import '../models/grid_size.dart';
import '../widgets/difficulty_button.dart';
import 'game_screen.dart';

/// The first screen: the player picks a difficulty and a new round starts.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  /// Opens the game board for the chosen grid size.
  void _startGame(BuildContext context, GridSize size) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => GameScreen(gridSize: size),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          // Scrolls on a very small screen instead of overflowing.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              // Keeps the buttons from stretching too wide on a tablet.
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Memory Match',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose a difficulty',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  DifficultyButton(
                    label: 'Easy',
                    size: GridSize.easy,
                    onPressed: () => _startGame(context, GridSize.easy),
                  ),
                  const SizedBox(height: 16),
                  DifficultyButton(
                    label: 'Medium',
                    size: GridSize.medium,
                    onPressed: () => _startGame(context, GridSize.medium),
                  ),
                  const SizedBox(height: 16),
                  DifficultyButton(
                    label: 'Hard',
                    size: GridSize.hard,
                    onPressed: () => _startGame(context, GridSize.hard),
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