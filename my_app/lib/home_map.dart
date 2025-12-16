import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_app/firestore_service.dart';

class HomeMap extends StatelessWidget {
  const HomeMap({super.key});

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
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(data['name']),
                    content: Text(data['description']),
                  ),
                );
              },
              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          );
        }).toList();
        /*--------------------------------------------------+
        | Mappa                                             |
        +--------------------------------------------------*/
        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(41.9028, 12.4964),
            initialZoom: 13,
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
