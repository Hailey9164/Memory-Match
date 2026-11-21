import 'package:flutter/material.dart';

import '../models/card_model.dart';

// Displays one card on the screen
class MemoryCardTile extends StatelessWidget {
  const MemoryCardTile({
    super.key,
    required this.card,
    required this.onTap,
  });

  // Card to display
  final MemoryCard card;

  // Function to call when the card is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Only face-down cards can be tapped
      onTap: card.isFaceDown ? onTap : null,

      // Displays the card's image or back depending on its state
      child: Image.asset(
        cardImagePath(),
        fit: BoxFit.cover,
      ),
    );
  }

  // Chooses the image to display based on the card's state
  String cardImagePath() {
    const folder = 'assets/cardThemes/animals';
    // Show the back of the card if it's face down
    if (card.isFaceDown) {
      return '$folder/card_back.png';
    }

    // Animal theme
    final faces = [
      'bear',
      'cat',
      'dog',
      'fox',
      'frog',
      'lion',
      'mouse',
      'owl',
      'panda',
      'penguin',
      'pig',
      'rabbit',
    ];

    // Uses the pair ID to choose an animal
    final face = faces[card.pairId % faces.length];

    // Shows the matched image if the card is matched, otherwise shows the face image
    if (card.isMatched) {
      return '$folder/card_matched_$face.png';
    }

    // Shows the face image if the card is face up
    return '$folder/card_face_$face.png';
  }


}