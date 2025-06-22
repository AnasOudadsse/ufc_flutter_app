import 'package:flutter/material.dart';
import '../models/ranking.dart';
import '../services/api_service.dart';
import 'fighter_list_screen.dart';

/// Shows all weight-class divisions for the chosen gender.
class WeightClassesScreen extends StatefulWidget {
  final String gender; // 'men' or 'women'

  const WeightClassesScreen({Key? key, required this.gender}) : super(key: key);

  @override
  _WeightClassesScreenState createState() => _WeightClassesScreenState();
}

class _WeightClassesScreenState extends State<WeightClassesScreen> {
  late Future<List<Ranking>> _futureRankings;

  @override
  void initState() {
    super.initState();
    // Kick off the network call only once
    _futureRankings = ApiService().getRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gender == 'men' ? 'Men’s Divisions' : 'Women’s Divisions',
        ),
      ),
      body: FutureBuilder<List<Ranking>>(
        future: _futureRankings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Still loading
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Network or parsing error
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // We have valid data
          final all = snapshot.data!;
          // Filter by prefix: e.g. 'mens-' or 'womens-'
          final filtered = all.where((r) {
            return widget.gender == 'men'
                ? r.id.startsWith('mens-')
                : r.id.startsWith('womens-');
          }).toList();

          if (filtered.isEmpty) {
            // No divisions found for this gender
            return const Center(child: Text('No divisions found.'));
          }

          // Display the list
          return ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final div = filtered[i];
              return ListTile(
                title: Text(div.categoryName),
                subtitle: Text('Champion: ${div.champion.championName}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FighterListScreen(
                        divisionId: div.id,
                        divisionName: div.categoryName,
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
