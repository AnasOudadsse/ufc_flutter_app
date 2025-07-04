import 'package:flutter/material.dart';
import '../models/ranking.dart';
import '../services/api_service.dart';
import 'fighter_detail_screen.dart';

/// Displays Pound-for-Pound rankings for both men and women.
class RankingScreen extends StatelessWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pound-for-Pound Rankings'),
          bottom: const TabBar(tabs: [Tab(text: 'Men'), Tab(text: 'Women')]),
        ),
        body: const TabBarView(
          children: [
            _P4PRankingList(gender: 'men'),
            _P4PRankingList(gender: 'women'),
          ],
        ),
      ),
    );
  }
}

/// Internal widget: fetches and displays one gender's P4P list.
class _P4PRankingList extends StatelessWidget {
  final String gender; // 'men' or 'women'
  const _P4PRankingList({Key? key, required this.gender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ranking>>(
      future: ApiService().getRankings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: \${snapshot.error}'));
        }
        final all = snapshot.data!;
        // Determine P4P category ID
        final p4pId =
            gender == 'men'
                ? 'mens-pound-for-pound-top-rank'
                : 'womens-pound-for-pound-top-rank';
        final ranking = all.firstWhere(
          (r) => r.id == p4pId,
          orElse: () => throw Exception('No P4P ranking for \$gender'),
        );
        final fighters = ranking.fighters;

        return ListView.separated(
          itemCount: fighters.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final fighter = fighters[index];
            final position = index + 1;
            final isChampion = fighter.id == ranking.champion.id;
            return ListTile(
              leading: Text(
                "$position",
                style: TextStyle(
                  fontWeight: isChampion ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              title: Text(
                fighter.name,
                style: TextStyle(
                  fontWeight: isChampion ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: isChampion ? const Text('Champion') : null,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FighterDetailScreen(fighterId: fighter.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
