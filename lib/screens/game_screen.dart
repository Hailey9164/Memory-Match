import 'package:flutter/material.dart';

import '../models/grid_size.dart';
import '../game/memory_game.dart';
import '../widgets/memory_card.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  // Creates a 4 by 4 board
  // Only creating a medium board for Phase 3
  late final MemoryGame game;

  @override
  void initState() {
    super.initState();

    // Creates the game using the Medium grid for now.
    game = MemoryGame(
      GridSize.medium,

      // Wrong cards stay visible for 1000 milliseconds.
      mismatchDelay: const Duration(milliseconds: 1000),
    );
  }
  @override
  void dispose() {
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

              // Column places the grid in the screen.
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      // Tells us the available width and height for the grid.
                      builder: (context, constraints) {
                        const spacing = 8.0;

                        // Finds the total space used by
                        // the gaps between columns.
                        final columnSpacing =
                            spacing *
                                (game.size.columns - 1);

                        // Finds the width of one card.
                        final cardWidth =
                            (constraints.maxWidth -
                                columnSpacing) /
                                game.size.columns;

                        // Finds the total space used by
                        // the gaps between rows.
                        final rowSpacing =
                            spacing *
                                (game.size.rows - 1);

                        // Finds the height of one card.
                        final cardHeight =
                            (constraints.maxHeight -
                                rowSpacing) /
                                game.size.rows;

                        // Tells Flutter the shape of each card.
                        final cardRatio =
                            cardWidth / cardHeight;

                        return GridView.builder(
                          // Creates one space for every card.
                          itemCount: game.cards.length,

                          // Sets up the rows and columns.
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            // Medium uses 4 columns.
                            crossAxisCount:
                            game.size.columns,

                            // Space between columns.
                            crossAxisSpacing: spacing,

                            // Space between rows.
                            mainAxisSpacing: spacing,

                            // Makes cards fit the available space.
                            childAspectRatio: cardRatio,
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
                        );
                      },
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