# Map Logic in Fighter Detail Screen

This document explains how the map feature works in the Fighter Detail screen of the UFC Flutter App frontend.

## Overview

- The app displays a map showing the birthplace of a fighter using **OpenStreetMap** tiles.
- Geocoding (converting address to coordinates) is done using the free **Nominatim** API.
- The map is rendered using the [`flutter_map`](https://pub.dev/packages/flutter_map) package, which is compatible with Flutter web, mobile, and desktop.

---

## 1. Geocoding with Nominatim

- When a fighter's birthplace is available, the app sends a request to the Nominatim API:
  - **Endpoint:** `https://nominatim.openstreetmap.org/search`
  - **Parameters:**
    - `q`: The address string (e.g., "Oahu, United States")
    - `format`: Always `json`
    - `limit`: Set to `1` to get the best match only
- The API returns a JSON array of results. The app extracts the latitude and longitude from the first result.
- Example Dart code:
  ```dart
  Future<LatLng?> _geocodeAddress(String address) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1');
    final response = await http.get(url, headers: {'User-Agent': 'ufc_flutter_app'});
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        return LatLng(lat, lon);
      }
    }
    return null;
  }
  ```

---

## 2. Displaying the Map with flutter_map

- If geocoding is successful, the app displays a map centered on the coordinates.
- The map uses OpenStreetMap tiles via the `TileLayer` widget.
- A marker is placed at the fighter's birthplace using the `MarkerLayer` widget.
- Example Dart code:
  ```dart
  SizedBox(
    height: 200,
    child: FlutterMap(
      options: MapOptions(
        center: pos, // LatLng from geocoding
        zoom: 10,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.ufc_flutter_app',
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
  )
  ```

---

## 3. Error Handling

- If the birthplace is empty or geocoding fails, a message is shown instead of the map.
- All network and parsing errors are caught and logged for debugging.

---

## 4. Why OpenStreetMap?

- **Free and open**: No API key or billing required.
- **Web compatible**: Works on all Flutter platforms.
- **Community supported**: Data is open and regularly updated.

---

## 5. References

- [flutter_map package](https://pub.dev/packages/flutter_map)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Nominatim Geocoding API](https://nominatim.org/release-docs/latest/api/Search/)
