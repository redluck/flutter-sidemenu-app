import 'package:flutter/material.dart';
import 'package:my_app/landmark_form/actions_row_form.dart';
import 'package:my_app/landmark_form/form_box.dart';
import 'package:my_app/landmark_form/form_map.dart';

class LandmarkForm extends StatefulWidget {
  const LandmarkForm({super.key});

  @override
  State<LandmarkForm> createState() => _LandmarkFormState();
}

class _LandmarkFormState extends State<LandmarkForm> {
  bool _isCollapsed = false;
  static const double _expandedHeight = 440;
  static const double _collapsedHeight = 75;
  late final FormMapController _mapController;
  double? _selectedLat;
  double? _selectedLon;

  void _onPositionSet(double lat, double lon) {
    setState(() {
      _selectedLat = lat;
      _selectedLon = lon;
    });
  }

  @override
  void initState() {
    super.initState();
    _mapController = FormMapController();
  }

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  Future<void> _onMyLocationPressed() async {
    await _mapController.centerOnCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Landmark Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1B5E20),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            /*====================================================================================================+
            | Mappa che riempie lo schermo                                                                        |
            +====================================================================================================*/
            Positioned.fill(
              child: FormMap(
                onPositionSet: _onPositionSet,
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
                      ActionsRowForm(
                        collapsed: _isCollapsed,
                        onOpenClosePressed: _toggleCollapse,
                        onMyLocationPressed: _onMyLocationPressed,
                      ),
                      /*--------------------------------------------------+
                      | Form                                              |
                      +--------------------------------------------------*/
                      FormBox(collapsed: _isCollapsed, latitude: _selectedLat, longitude: _selectedLon),
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
