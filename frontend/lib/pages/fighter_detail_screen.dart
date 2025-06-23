import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/fighter_detail.dart';
import '../services/api_service.dart';

/// Screen displaying detailed information about a single fighter,
/// including a map of their birthplace (web-compatible HTTP geocoding).
class FighterDetailScreen extends StatefulWidget {
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
    _futureFighter = ApiService().getFighterDetail(widget.fighterId);
  }

  /// Uses Nominatim (OpenStreetMap) for free geocoding
  Future<LatLng?> _geocodeAddress(String address) async {
    if (address.isEmpty) return null;
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'ufc_flutter_app'},
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
    } catch (e) {
      debugPrint('Geocode error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fighter Details')),
      body: FutureBuilder<FighterDetail>(
        future: _futureFighter,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            debugPrint('API error: ${snap.error}');
            return const Center(child: Text('Failed to load fighter.'));
          }
          final fighter = snap.data;
          if (fighter == null) return const Center(child: Text('No data.'));

          // Keep existing CORS proxy logic for images
          final proxiedUrl = 'https://proxy.cors.sh/${fighter.imgUrl}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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
                      loadingBuilder:
                          (c, child, prog) =>
                              prog == null
                                  ? child
                                  : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      errorBuilder:
                          (c, e, s) => const Icon(Icons.broken_image, size: 80),
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
                const SizedBox(height: 32),
                // Map section
                if (fighter.placeOfBirth.isEmpty)
                  const Text('No birthplace provided.')
                else
                  FutureBuilder<LatLng?>(
                    future: _geocodeAddress(fighter.placeOfBirth),
                    builder: (c, gSnap) {
                      if (gSnap.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (gSnap.hasError)
                        debugPrint('Map error: ${gSnap.error}');
                      final pos = gSnap.data;
                      if (pos == null) return const Text('Map not available.');
                      return SizedBox(
                        height: 200,
                        child: FlutterMap(
                          options: MapOptions(center: pos, zoom: 10),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                              userAgentPackageName:
                                  'com.example.ufc_flutter_app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: pos,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

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
