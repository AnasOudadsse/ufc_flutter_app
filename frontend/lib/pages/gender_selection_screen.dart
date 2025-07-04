import 'package:flutter/material.dart';
import 'package:ufc_flutter_app/pages/ranking_screen.dart';
import 'weight_classes_screen.dart'; // we'll build this next
import 'favorites_page.dart';

/// Lets the user choose Men's or Women's divisions.
class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    WeightClassesScreen(gender: 'men'),
    WeightClassesScreen(gender: 'women'),
    RankingScreen(),
    FavoritesPage(),
  ];

  static const List<String> _titles = [
    "Men's Divisions",
    "Women's Divisions",
    'Ranking',
    'Favorites',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.male),
            label: "Men's Divisions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.female),
            label: "Women's Divisions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
