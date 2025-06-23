import 'package:flutter/material.dart';
import '../models/fighter_detail.dart';
import '../services/api_service.dart';

/// Screen displaying detailed information about a single fighter.
class FighterDetailScreen extends StatefulWidget {
  /// ID of the fighter to fetch.
  final String fighterId;

  const FighterDetailScreen({Key? key, required this.fighterId})
    : super(key: key);

  @override
  _FighterDetailScreenState createState() => _FighterDetailScreenState();
}

class _FighterDetailScreenState extends State<FighterDetailScreen> {
  late Future<FighterDetail> _futureFighter;

  @override
  void initState() {
    super.initState();
    // Kick off the API call
    _futureFighter = ApiService().getFighterDetail(widget.fighterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fighter Details')),
      body: FutureBuilder<FighterDetail>(
        future: _futureFighter,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final fighter = snapshot.data!;

          // Proxy image requests through a CORS proxy to prevent browser
          // cross-origin errors when running on the web.
          final proxiedUrl = 'https://proxy.cors.sh/${fighter.imgUrl}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fighter.imgUrl.isNotEmpty)
                  Center(
                    child: Image.network(
                      proxiedUrl,
                      height: 200,
                      fit: BoxFit.contain,
                      headers: const {
                        'x-cors-api-key':
                            'temp_904ff571b848f9d23f6896b901b91e3d',
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                    : null,
                          ),
                        );
                      },
                      errorBuilder:
                          (context, error, stack) =>
                              const Icon(Icons.broken_image, size: 80),
                    ),
                  ),

                const SizedBox(height: 16),
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

                const Divider(height: 32),
                Text(
                  'Record: ${fighter.wins}-${fighter.losses}-${fighter.draws}',
                ),
                Text('Age: ${fighter.age}'),
                Text('Height: ${fighter.height}"'),
                Text('Weight: ${fighter.weight} lbs'),
                Text('Reach: ${fighter.reach}"'),
                Text('Leg Reach: ${fighter.legReach}"'),

                const Divider(height: 32),
                _infoRow('Division', fighter.category),
                _infoRow('Status', fighter.status),
                _infoRow('Debut', fighter.octagonDebut),
                _infoRow('Birthplace', fighter.placeOfBirth),
                _infoRow('Trains At', fighter.trainsAt),
                _infoRow('Style', fighter.fightingStyle),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper to render label + value rows
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
