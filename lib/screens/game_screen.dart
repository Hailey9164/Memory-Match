import 'package:flutter/material.dart';

import '../game/memory_game.dart';
import '../models/grid_size.dart';
import '../utils/board_layout.dart';
import '../widgets/memory_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.gridSize = GridSize.medium});

  // The difficulty to play: Easy, Medium, or Hard.
  final GridSize gridSize;

  @override
  State<GameScreen> createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  late final MemoryGame game;

  @override
  void initState() {
    super.initState();

    // Creates the game using the grid chosen on the menu.
    game = MemoryGame(
      widget.gridSize,

      // Wrong cards stay visible for 1000 milliseconds.
      mismatchDelay: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    // Stops a pending flip-back so it cannot run after the screen is gone.
    game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // MemoryGame extends ChangeNotifier.
      // This rebuilds the screen when a card changes.
      animation: game,

      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Memory Game'),
            centerTitle: true,
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),

              child: LayoutBuilder(
                // Tells us the available width and height for the grid.
                builder: (context, constraints) {
                  const spacing = 8.0;

                  // Finds the biggest cards that keep the 8:11 card shape
                  // and still fit every row and column on the screen.
                  final layout = boardLayout(
                    game.size,
                    Size(constraints.maxWidth, constraints.maxHeight),
                    spacing: spacing,
                  );

                  // Centers the grid in the space that is left over.
                  return Center(
                    child: SizedBox(
                      width: layout.gridWidth,
                      height: layout.gridHeight,

                      child: GridView.builder(
                        // The grid already fits, so it never scrolls.
                        physics: const NeverScrollableScrollPhysics(),

                        // Creates one space for every card.
                        itemCount: game.cards.length,

                        // Sets up the rows and columns.
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          // Easy uses 3 columns, Medium and Hard use 4.
                          crossAxisCount: game.size.columns,

                          // Space between columns.
                          crossAxisSpacing: spacing,

                          // Space between rows.
                          mainAxisSpacing: spacing,

                          // Every card has the same 8:11 shape as the images.
                          childAspectRatio: cardAspectRatio,
                        ),

                        // Builds each card.
                        itemBuilder: (context, index) {
                          // Gets the card at this position.
                          final card = game.cards[index];

                          return MemoryCardTile(
                            // Sends the card to the card widget.
                            card: card,

                            // Sends the card's ID to the
                            // MemoryGame logic when tapped.
                            onTap: () {
                              game.flip(card.id);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // The two buttons under the board.
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  // Restart deals a new shuffled board on the same difficulty.
                  Expanded(
                    child: OutlinedButton(
                      onPressed: game.restart,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Restart'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Menu goes back to the difficulty screen.
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Menu'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}