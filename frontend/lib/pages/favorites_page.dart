import 'package:flutter/material.dart';
import '../services/favorites_db.dart';
import '../models/favorite_fighter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class GeocodeResult {
  final String address;
  final LatLng? coords;
  final String? error;
  GeocodeResult(this.address, this.coords, [this.error]);
}

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool _showMap = false;

  Future<GeocodeResult> _geocodeWithDebug(String address) async {
    if (address.isEmpty) return GeocodeResult(address, null, 'Empty address');
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
          return GeocodeResult(address, LatLng(lat, lon));
        } else {
          return GeocodeResult(address, null, 'No results');
        }
      } else {
        return GeocodeResult(address, null, 'HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Geocode error for $address: $e');
      return GeocodeResult(address, null, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Fighters')),
      body: FutureBuilder<List<FavoriteFighter>>(
        future: FavoritesDb().getFavorites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final favorites = snapshot.data!;
          if (favorites.isEmpty)
            return Center(child: Text('No favorites yet.'));
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showMap = !_showMap;
                    });
                  },
                  child: Text(_showMap ? 'Hide Map' : 'Show Map'),
                ),
              ),
              if (_showMap)
                Expanded(
                  child: FutureBuilder<List<GeocodeResult>>(
                    future: Future.wait(
                      favorites
                          .map((f) => _geocodeWithDebug(f.placeOfBirth))
                          .toList(),
                    ),
                    builder: (context, geoSnap) {
                      if (geoSnap.hasError) {
                        return Center(
                          child: Text('Error loading map: ${geoSnap.error}'),
                        );
                      }
                      if (!geoSnap.hasData)
                        return Center(child: CircularProgressIndicator());
                      final results = geoSnap.data!;
                      final validCoords =
                          results
                              .where((r) => r.coords != null)
                              .map((r) => r.coords!)
                              .toList();
                      LatLng? center =
                          validCoords.isNotEmpty ? validCoords.first : null;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Geocoding results:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...results.map(
                            (r) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              child: Text(
                                '${r.address} => '
                                '${r.coords != null ? 'OK (${r.coords!.latitude}, ${r.coords!.longitude})' : 'ERROR: ${r.error}'}',
                                style: TextStyle(
                                  color:
                                      r.coords != null
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ),
                          ),
                          if (center == null)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'No valid locations for map.',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          if (center != null)
                            SizedBox(
                              height: 200,
                              child: FlutterMap(
                                options: MapOptions(center: center, zoom: 2),
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
                                      for (final pos in validCoords)
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
                            ),
                        ],
                      );
                    },
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final fighter = favorites[index];
                    return ListTile(
                      leading: Image.network(
                        fighter.imgUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(fighter.name),
                      // Add navigation to detail if needed
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
