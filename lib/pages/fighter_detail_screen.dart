// lib/screens/fighter_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/fighter_detail.dart';
import '../services/api_service.dart';

/// Screen displaying detailed information about a single fighter.
class FighterDetailScreen extends StatefulWidget {
  /// ID of the fighter to fetch.
  final String fighterId;

  const FighterDetailScreen({
    Key? key,
    required this.fighterId,
  }) : super(key: key);

  @override
  _FighterDetailScreenState createState() => _FighterDetailScreenState();
}

class _FighterDetailScreenState extends State<FighterDetailScreen> {
  late Future<FighterDetail> _futureFighter;

  @override
  void initState() {
    super.initState();
    // Kick off API call to fetch fighter details
    _futureFighter = ApiService().getFighterDetail(widget.fighterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fighter Details'),
      ),
      body: FutureBuilder<FighterDetail>(
        future: _futureFighter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final fighter = snapshot.data!;
          // Display all fighter properties
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fighter image
                if (fighter.imgUrl.isNotEmpty)
                  Center(
                    child: Image.network(
                      fighter.imgUrl,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                const SizedBox(height: 16),
                // Name and nickname
                Text(
                  fighter.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (fighter.nickname.isNotEmpty)
                  Text(
                    '"${fighter.nickname}"',
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 16),
                // Stats
                Text('Record: ${fighter.wins}-${fighter.losses}-${fighter.draws}'),
                Text('Age: ${fighter.age}'),
                Text('Height: ${fighter.height}"'),
                Text('Weight: ${fighter.weight} lbs'),
                Text('Reach: ${fighter.reach}"'),
                Text('Leg Reach: ${fighter.legReach}"'),
                const SizedBox(height: 16),
                // Additional info
                Text('Debut: ${fighter.octagonDebut}'),
                Text('Birthplace: ${fighter.placeOfBirth}'),
                Text('Trains At: ${fighter.trainsAt}'),
                Text('Style: ${fighter.fightingStyle}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
