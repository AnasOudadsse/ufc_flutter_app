import 'package:flutter/material.dart';
import 'package:ufc_flutter_app/pages/gender_selection_screen.dart';

void main() {
  runApp(const MmaApp());
}

/// Root of our application.
class MmaApp extends StatelessWidget {
  const MmaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp sets up theme, routing, etc.
    return MaterialApp(
      title: 'MMA Explorer',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const GenderSelectionScreen(),
    );
  }
}
