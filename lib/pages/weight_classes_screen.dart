import 'package:flutter/material.dart';

/// A stub screen so we can test navigation.
/// Later, we'll replace the body with real API-driven content.
class WeightClassesScreen extends StatelessWidget {
  final String gender;

  /// We expect a 'gender' argument when navigating here.
  const WeightClassesScreen({
    Key? key,
    required this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Basic page structure: an AppBar and centered text.
      appBar: AppBar(
        title: Text(
          // Show which gender we passed in.
          gender == 'men' ? 'Men’s Divisions' : 'Women’s Divisions',
        ),
      ),
      body: Center(
        // Inform us that the stub is working.
        child: Text(
          'Stub: will show $gender weight classes here',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
