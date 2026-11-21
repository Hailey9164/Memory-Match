import 'package:flutter/material.dart';

import 'screens/game_screen.dart';

void main() {
  runApp(const MemoryMatchApp());
}

/// The root of the app. For now it opens straight to the game screen.
/// When the menu screen exists, change `home` to point at it.
class MemoryMatchApp extends StatelessWidget {
  const MemoryMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Match',
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}