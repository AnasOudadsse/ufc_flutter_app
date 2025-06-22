// lib/screens/fighter_list_screen.dart

import 'package:flutter/material.dart';
import '../models/ranking.dart';
import '../services/api_service.dart';
import 'fighter_detail_screen.dart';

/// Screen that displays the list of fighters in a division.
class FighterListScreen extends StatefulWidget {
  /// ID of the division to fetch (e.g. "flyweight").
  final String divisionId;
  /// Display name of the division (e.g. "Flyweight").
  final String divisionName;

  const FighterListScreen({
    Key? key,
    required this.divisionId,
    required this.divisionName,
  }) : super(key: key);

  @override
  _FighterListScreenState createState() => _FighterListScreenState();
}

class _FighterListScreenState extends State<FighterListScreen> {
  late Future<Ranking> _futureDivision;

  @override
  void initState() {
    super.initState();
    // Fetch the division details when this screen initializes
    _futureDivision = ApiService().getDivision(widget.divisionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.divisionName),
      ),
      body: FutureBuilder<Ranking>(
        future: _futureDivision,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading spinner while waiting for data
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Display error if something went wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Data loaded successfully
          final division = snapshot.data!;
          final fighters = division.fighters;

          if (fighters.isEmpty) {
            // No fighters in this division
            return const Center(child: Text('No fighters found.'));
          }

          // Display list of fighters
          return ListView.separated(
            itemCount: fighters.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final fighter = fighters[index];
              return ListTile(
                title: Text(fighter.name),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to fighter detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FighterDetailScreen(
                        fighterId: fighter.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
