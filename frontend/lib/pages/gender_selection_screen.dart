import 'package:flutter/material.dart';
import 'package:ufc_flutter_app/pages/ranking_screen.dart';
import 'weight_classes_screen.dart'; // we’ll build this next

/// Lets the user choose Men’s or Women’s divisions.
class GenderSelectionScreen extends StatelessWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Division')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to next screen, passing 'men'
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WeightClassesScreen(gender: 'men'),
                  ),
                );
              },
              child: const Text('Men’s Divisions'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to next screen, passing 'women'
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WeightClassesScreen(gender: 'women'),
                  ),
                );
              },
              child: const Text('Women’s Divisions'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to next screen, passing 'women'
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RankingScreen(),
                  ),
                );
              },
              child: const Text('Ranking'),
            ),
          ],
        ),
      ),
    );
  }
}
