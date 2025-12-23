import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_app/firestore_service.dart';

class HomeMap extends StatefulWidget {
  final HomeMapController controller;
  final void Function(String name, String description) onMarkerTap;

  const HomeMap({
    super.key,
    required this.controller,
    required this.onMarkerTap,
  });

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    widget.controller.bind(_moveTo);
  }

  void _moveTo(double lat, double lon) {
    double offsetKm = 0.4;     // Km verso nord per centrare sopra la lista
    const kmPerDegree = 111.0; // Costante: 1 grado di latitudine = 111 km sulla superficie terrestre
    final shiftedLat = lat - (offsetKm / kmPerDegree);
    final point = LatLng(shiftedLat, lon);
    _mapController.move(point, 16.0);
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

/*====================================================================================================+
| HomeMapController                                                                                   |
+====================================================================================================*/
class HomeMapController {
  // Riferimento al metodo interno della mappa (_moveTo) che effettua lo spostamento
  // viene assegnato tramite bind() quando la mappa è pronta
  void Function(double lat, double lon)? _move;

  // Serve a collegare il controller al metodo interno della mappa (_moveTo)
  // viene chiamato da HomeMap nello initState.
  void bind(void Function(double lat, double lon) fn) {
    _move = fn;
  }

  // Questo è il metodo pubblico che chiama la mappa per muovere il centro
  // viene usato da altri widget, ad esempio la lista, senza fare setState
  void moveTo(double lat, double lon) {
    _move?.call(lat, lon); // Se _move non è ancora assegnato, non fa nulla
  }
}
