import 'package:flutter/material.dart';
import 'package:my_app/page_1_widgets/actions_row.dart';
import 'package:my_app/page_1_widgets/detail_card.dart';
import 'package:my_app/page_1_widgets/home_map.dart';
import 'package:my_app/page_1_widgets/landmarks_list.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  bool _isCollapsed = false;
  bool _markerTapped = false;
  String _selectedId = '';
  String _selectedTitle = '';
  String _selectedDescription = '';
  late final ScrollController _listController;
  late final HomeMapController _mapController;
  static const double _expandedHeight = 440;
  static const double _collapsedHeight = 75;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _mapController = HomeMapController();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  void _onMarkerTap(String id, String name, String description) {
    setState(() {
      _selectedId = id;
      _selectedTitle = name;
      _selectedDescription = description;
      _isCollapsed = false;
      _markerTapped = true;
    });
  }

  void _onIconListPressed() {
    setState(() {
      _markerTapped = false;
    });
  }

  void _onListItemPressed(double lat, double lon) {
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
                              onItemTap: (lat, lon) {
                                _onListItemPressed(
                                  lat.toDouble(),
                                  lon.toDouble(),
                                );
                              },
                            )
                          : DetailCard(
                              placeId: _selectedId,
                              title: _selectedTitle,
                              description: _selectedDescription,
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
