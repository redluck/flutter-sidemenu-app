import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  bool _isCollapsed = false;

  static const double _expandedHeight = 440;
  static const double _collapsedHeight = 120;

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /*====================================================================================================+
            | Mappa che riempie lo schermo                                                                        |
            +====================================================================================================*/
            Positioned.fill(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(41.9028, 12.4964),
                  initialZoom: 13,
                ),
                // `flutter_map` v8 uses `children` instead of the old `layers` API.
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=k8cZ1Gqxm0TUPe6i10L8",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  // Marker on Rome
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(41.8902, 12.4922),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            /*====================================================================================================+
            | Div fisso sotto la mappa (overlay) con comportamento collapse/expand                                |
            +====================================================================================================*/
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                /*--------------------------------------------------+
                | Div                                               |
                +--------------------------------------------------*/
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.easeInOut,
                  height: _isCollapsed ? _collapsedHeight : _expandedHeight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row con il pulsante espandi/riduci
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isCollapsed
                                  ? Icons.open_in_full
                                  : Icons.close_fullscreen,
                            ),
                            tooltip: _isCollapsed ? 'Espandi' : 'Riduci',
                            onPressed: _toggleCollapse,
                          ),
                        ],
                      ),
                      // Row principale con info e azione
                      Container(
                        height: 56,
                        color: Colors.grey[100],
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Indirizzo o info',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Dettagli aggiuntivi qui',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('Azione'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
