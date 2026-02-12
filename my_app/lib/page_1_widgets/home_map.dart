import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_app/firestore_service.dart';

class HomeMap extends StatefulWidget {
  final HomeMapController controller;
  final void Function(String id, String name, String description, String set, double latitude, double longitude) onMarkerTap;
  final ValueNotifier<String> selectedPlaceIdNotifier;

  const HomeMap({
    super.key,
    required this.controller,
    required this.onMarkerTap,
    required this.selectedPlaceIdNotifier,
  });

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    widget.controller.bind(_moveTo);
    widget.controller.bindCurrentLocation(_centerOnCurrentLocation);
  }

  void _moveTo(double lat, double lon) {
    double offsetKm = 0.4;     // Km verso nord per centrare sopra la lista
    const kmPerDegree = 111.0; // Costante: 1 grado di latitudine = 111 km sulla superficie terrestre
    final shiftedLat = lat - (offsetKm / kmPerDegree);
    final point = LatLng(shiftedLat, lon);
    _mapController.move(point, 16.0);
  }

  Future<void> _centerOnCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      // Verificare i permessi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() => _isLoadingLocation = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Permesso di localizzazione negato'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
              ),
            );
          }
          return;
        }
      }

      // Ottenere la posizione corrente
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLocation = newLocation;
        _isLoadingLocation = false;
      });

      // Centrare la mappa sulla posizione corrente
      _moveTo(position.latitude, position.longitude);
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nella localizzazione: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /*--------------------------------------------------+
    | Elenco dei markers                                |
    +--------------------------------------------------*/
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirestoreService().getPlaces(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return ValueListenableBuilder<String>(
              valueListenable: widget.selectedPlaceIdNotifier,
              builder: (context, selectedId, _) {
                final markers = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final isSelected = doc.id == selectedId;

                  return Marker(
                    point: LatLng(data['latitude'], data['longitude']),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => widget.onMarkerTap(
                        doc.id, 
                        data['name'], 
                        data['description'],
                        data['set'] ?? '',
                        data['latitude'],
                        data['longitude'],
                      ),
                      child: Icon(
                        Icons.circle,
                        color: isSelected ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                  );
                }).toList();

                // Aggiungere il marker della posizione corrente se disponibile
                if (_currentLocation != null) {
                  markers.add(
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.adjust,
                        color: Colors.blue[700],
                        size: 40,
                      ),
                    ),
                  );
                }

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
          },
        ),
        // Loader di caricamento della posizione
        if (_isLoadingLocation)
          Container(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 100),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Localizzazione in corso...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        // Attribuzione mappa
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            color: Colors.white.withValues(alpha: 0.8),
            child: const Text(
              '© MapTiler © OpenStreetMap contributors',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ),
        // Messaggio di istruzione
        Positioned(
          top: 24,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Clicca su un marker per vedere i dettagli',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
  
  // Riferimento al metodo interno della mappa (_centerOnCurrentLocation)
  // viene assegnato tramite bindCurrentLocation() quando la mappa è pronta
  Future<void> Function()? _centerOnCurrentLocation;

  // Serve a collegare il controller al metodo interno della mappa (_moveTo)
  // viene chiamato da HomeMap nello initState.
  void bind(void Function(double lat, double lon) fn) {
    _move = fn;
  }

  // Serve a collegare il controller al metodo interno della mappa (_centerOnCurrentLocation)
  // viene chiamato da HomeMap nello initState.
  void bindCurrentLocation(Future<void> Function() fn) {
    _centerOnCurrentLocation = fn;
  }

  // Questo è il metodo pubblico che chiama la mappa per muovere il centro
  // viene usato da altri widget, ad esempio la lista, senza fare setState
  void moveTo(double lat, double lon) {
    _move?.call(lat, lon); // Se _move non è ancora assegnato, non fa nulla
  }

  // Questo è il metodo pubblico che chiama la mappa per centrarsi sulla posizione corrente
  Future<void> centerOnCurrentLocation() async {
    await _centerOnCurrentLocation?.call();
  }
}
