import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_app/firestore_service.dart';

class HomeMap extends StatefulWidget {
  final void Function(String name, String description) onMarkerTap;
  final double lat;
  final double lon;

  const HomeMap({
    super.key,
    required this.onMarkerTap,
    required this.lat,
    required this.lon,
  });

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final MapController _mapController = MapController();

  void centerMapAndAddMarker({
    required double latitude,
    required double longitude,
    double offsetKm = 0.4, // Km verso nord per centrare sopra la lista
  }) {
    // Costante: 1 grado di latitudine = 111 km sulla superficie terrestre
    const kmPerDegree = 111.0;
    final shiftedLat = latitude - (offsetKm / kmPerDegree);
    final point = LatLng(shiftedLat, longitude);
    _mapController.move(point, 16.0);
  }

  @override
  void didUpdateWidget(covariant HomeMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.lat != widget.lat || oldWidget.lon != widget.lon) {
      centerMapAndAddMarker(latitude: widget.lat, longitude: widget.lon);
    }
  }

  @override
  Widget build(BuildContext context) {
    /*--------------------------------------------------+
    | Elenco dei markers                                |
    +--------------------------------------------------*/
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService().getPlaces(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final markers = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return Marker(
            point: LatLng(data['latitude'], data['longitude']),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () =>
                  widget.onMarkerTap(data['name'], data['description']),
              child: const Icon(Icons.circle, color: Colors.red, size: 20),
            ),
          );
        }).toList();
        /*--------------------------------------------------+
        | Mappa                                             |
        +--------------------------------------------------*/
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(41.9028, 12.4964),
            initialZoom: 16,
          ),
          // `flutter_map` v8 uses `children` instead of the old `layers` API.
          children: [
            TileLayer(
              urlTemplate:
                  "https://api.maptiler.com/maps/streets-v4/{z}/{x}/{y}.png?key=k8cZ1Gqxm0TUPe6i10L8",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}
