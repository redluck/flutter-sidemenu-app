import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(41.9028, 12.4964),
        initialZoom: 13,
      ),
      // `flutter_map` v8 uses `children` instead of the old `layers` API.
      children: [
        TileLayer(
          urlTemplate:
              "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=k8cZ1Gqxm0TUPe6i10L8",
          subdomains: ['a', 'b', 'c'],
        ),
        // Marker on Rome
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(41.8902, 12.4922),
              width: 40,
              height: 40,
              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}
