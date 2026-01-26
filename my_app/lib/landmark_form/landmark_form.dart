import 'package:flutter/material.dart';
import 'package:my_app/landmark_form/form_map.dart';

class LandmarkForm extends StatefulWidget {
  const LandmarkForm({super.key});

  @override
  State<LandmarkForm> createState() => _LandmarkFormState();
}

class _LandmarkFormState extends State<LandmarkForm> {
  late final FormMapController _mapController;

  void _onMarkerTap(String name, String description) {}

  @override
  void initState() {
    super.initState();
    _mapController = FormMapController();
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
                onMarkerTap: _onMarkerTap,
                controller: _mapController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
