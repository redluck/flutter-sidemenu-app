import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        // In recent flutter_map versions the initial viewport is provided with
        // `initialCenter` and `initialZoom`.
        initialCenter: LatLng(37.42796133580664, -122.085749655962),
        initialZoom: 14,
      ),
      // `flutter_map` v8 uses `children` instead of the old `layers` API.
      children: [
        TileLayer(
          urlTemplate:
              "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=k8cZ1Gqxm0TUPe6i10L8",
          subdomains: ['a', 'b', 'c'],
        ),
      ],
    );
  }
}
