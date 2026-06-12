import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_app/page_1_widgets/actions_row.dart';
import 'package:my_app/page_1_widgets/detail_card.dart';
import 'package:my_app/page_1_widgets/home_map.dart';
import 'package:my_app/page_1_widgets/landmarks_list.dart';

class Page1 extends StatefulWidget {
  final String? filterBySet;
  final double? initialLatitude;
  final double? initialLongitude;

  const Page1({
    super.key,
    this.filterBySet,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  bool _isCollapsed = false;
  bool _markerTapped = false;
  String _selectedId = '';
  late final ValueNotifier<String> _selectedIdNotifier;
  String _selectedTitle = '';
  String _selectedDescription = '';
  String _selectedSet = '';
  double _selectedLatitude = 0.0;
  double _selectedLongitude = 0.0;
  late final ScrollController _listController;
  late final HomeMapController _mapController;
  static const double _expandedHeight = 440;
  static const double _collapsedHeight = 75;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _mapController = HomeMapController();
    _selectedIdNotifier = ValueNotifier<String>('');
  }

  @override
  void dispose() {
    _listController.dispose();
    _selectedIdNotifier.dispose();
    super.dispose();
  }

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  void _onMarkerTap(String id, String name, String description, String set, double latitude, double longitude) {
    setState(() {
      _selectedId = id;
      _selectedIdNotifier.value = id;
      _selectedTitle = name;
      _selectedDescription = description;
      _selectedSet = set;
      _selectedLatitude = latitude;
      _selectedLongitude = longitude;
      _isCollapsed = false;
      _markerTapped = true;
    });
  }

  void _onIconListPressed() {
    setState(() {
      _markerTapped = false;
    });
  }

  void _onListItemPressed(String id, double lat, double lon) {
    _selectedIdNotifier.value = id;
    _mapController.moveTo(lat, lon);
  }

  Future<void> _onMyLocationPressed() async {
    await _mapController.centerOnCurrentLocation();
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
              child: HomeMap(
                onMarkerTap: _onMarkerTap,
                controller: _mapController,
                selectedPlaceIdNotifier: _selectedIdNotifier,
                selectedSet: widget.filterBySet,
                initialCenter: widget.initialLatitude != null && widget.initialLongitude != null
                    ? LatLng(widget.initialLatitude!, widget.initialLongitude!)
                    : null,
              ),
            ),
            /*====================================================================================================+
            | Div fisso sotto la mappa con comportamento collapse/expand                                          |
            +====================================================================================================*/
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
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
                      | Row con i pulsanti                                |
                      +--------------------------------------------------*/
                      ActionsRow(
                        collapsed: _isCollapsed,
                        listIconVisible: _markerTapped,
                        onOpenClosePressed: _toggleCollapse,
                        onListPressed: _onIconListPressed,
                        onMyLocationPressed: _onMyLocationPressed,
                      ),
                      /*--------------------------------------------------+
                      | Lista                                             |
                      +--------------------------------------------------*/
                      !_markerTapped
                          ? LandmarksList(
                              collapsed: _isCollapsed,
                              scrollController: _listController,
                              selectedPlaceIdNotifier: _selectedIdNotifier,
                              selectedSet: widget.filterBySet,
                              onItemTap: (id, lat, lon) {
                                _onListItemPressed(
                                  id,
                                  lat.toDouble(),
                                  lon.toDouble(),
                                );
                              },
                            )
                          : DetailCard(
                              placeId: _selectedId,
                              title: _selectedTitle,
                              description: _selectedDescription,
                              set: _selectedSet,
                              latitude: _selectedLatitude,
                              longitude: _selectedLongitude,
                              collapsed: _isCollapsed,
                              onDelete: _onIconListPressed,
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
