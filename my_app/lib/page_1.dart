import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'address_row.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  bool _isCollapsed = false;

  static const double _expandedHeight = 440;
  static const double _collapsedHeight = 115;

  final ScrollController _scrollController = ScrollController();

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
                      /*--------------------------------------------------+
                      | Row con il pulsante espandi/riduci                |
                      +--------------------------------------------------*/
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
                      /*--------------------------------------------------+
                      |                                                   |
                      +--------------------------------------------------*/
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          height: _isCollapsed
                              ? _collapsedHeight
                              : _expandedHeight,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('places')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final docs = snapshot.data?.docs ?? [];
                              if (docs.isEmpty) {
                                return const Center(
                                  child: Text('No places yet'),
                                );
                              }

                              return ListView.builder(
                                itemCount: docs.length,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                itemBuilder: (context, index) {
                                  final place = docs[index];
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {},
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 12,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(8),
                                        title: Text(place['name'] ?? ''),
                                        subtitle: Text(
                                          place['description'] ?? '',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
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
