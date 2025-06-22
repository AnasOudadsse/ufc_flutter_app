// lib/screens/weight_classes_screen.dart

import 'package:flutter/material.dart';
import '../models/ranking.dart';
import '../services/api_service.dart';
import 'fighter_list_screen.dart';

/// Screen showing weight-class divisions filtered by gender (men vs women).
class WeightClassesScreen extends StatefulWidget {
  /// 'men' or 'women'
  final String gender;

  const WeightClassesScreen({
    Key? key,
    required this.gender,
  }) : super(key: key);

  @override
  _WeightClassesScreenState createState() => _WeightClassesScreenState();
}

class _WeightClassesScreenState extends State<WeightClassesScreen> {
  late Future<List<Ranking>> _futureRankings;

  @override
  void initState() {
    super.initState();
    // 1. Start fetching all divisions from the API
    _futureRankings = ApiService().getRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 2. Dynamic title based on selected gender
        title: Text(
          widget.gender == 'men' ? 'Men’s Divisions' : 'Women’s Divisions',
        ),
      ),
      body: FutureBuilder<List<Ranking>>(
        future: _futureRankings,
        builder: (context, snapshot) {
          // 3. Show loading spinner while waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 4. Handle errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 5. Data loaded successfully
          final allDivisions = snapshot.data!;

          // 6. Filter out P4P rankings and split by gender
          final menClasses = allDivisions.where((r) =>
            !r.id.startsWith('womens-') ||
            r.id.contains('mens-pound-for-pound')
          ).toList();

          final womenClasses = allDivisions.where((r) =>
            r.id.startsWith('womens-') ||
            r.id.contains('womens-pound-for-pound')
          ).toList();

          final filtered = widget.gender == 'men' ? menClasses : womenClasses;

          // 7. Show message if no divisions found
          if (filtered.isEmpty) {
            return const Center(child: Text('No divisions found.'));
          }

          // 8. Display list of divisions
          return ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final division = filtered[index];
              return ListTile(
                title: Text(division.categoryName),
                subtitle: Text('Champion: ${division.champion.championName}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // 9. Navigate to list of fighters for this division
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FighterListScreen(
                        divisionId: division.id,
                        divisionName: division.categoryName,
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
