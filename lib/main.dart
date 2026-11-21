import 'package:flutter/material.dart';

import 'screens/menu_screen.dart';

void main() {
  runApp(const MemoryMatchApp());
}

/// The root of the app. It opens on the difficulty menu.
class MemoryMatchApp extends StatelessWidget {
  const MemoryMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Match',
      debugShowCheckedModeBanner: false,
      home: const MenuScreen(),
    );
  }
}