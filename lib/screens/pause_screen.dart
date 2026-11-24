import 'package:flutter/material.dart';

import '../game/memory_game.dart';

// Screen shown when pause button is pressed
// Should pause the timer, have a resume button that continues timer/game
// and include the option to go back to the main menu
class PauseScreen extends StatelessWidget {
  const PauseScreen({
    super.key,
    required this.game,
  });

  final MemoryGame game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding (
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Game Paused',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

              // Resume button
                SizedBox (
                  width: 100,
                  height: 50,
                  child: FilledButton (
                    onPressed: (){
                      // Resume the game and pop the pause screen
                      Navigator.of(context).maybePop();
                      game.resume();
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(150, 48),
                    ),
                    child: const Text('Resume'),
                  ),
                ),
              ],
            ),
         ),
        ),
      ),
    );
  }
}