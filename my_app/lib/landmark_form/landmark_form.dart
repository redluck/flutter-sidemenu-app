import 'package:flutter/material.dart';

class LandmarkForm extends StatefulWidget {
  const LandmarkForm({super.key});

  @override
  State<LandmarkForm> createState() => _LandmarkFormState();
}

class _LandmarkFormState extends State<LandmarkForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Landmark Form')),
      body: const Center(child: Text('Landmark Form')),
    );
  }
}
