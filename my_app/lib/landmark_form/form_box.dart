import 'package:flutter/material.dart';
import '../firestore_service.dart';

class FormBox extends StatefulWidget {
  final bool collapsed;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final String? initialName;
  final String? initialDescription;
  final String? initialSet;

  const FormBox({
    super.key,
    required this.collapsed,
    required this.latitude,
    required this.longitude,
    this.placeId,
    this.initialName,
    this.initialDescription,
    this.initialSet,
  });

  @override
  State<FormBox> createState() => _FormBoxState();
}

class _FormBoxState extends State<FormBox> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  final _scrollController = ScrollController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _setController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Popola i controller con i valori iniziali se presenti
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
    if (widget.initialDescription != null) {
      _descriptionController.text = widget.initialDescription!;
    }
    if (widget.initialSet != null) {
      _setController.text = widget.initialSet!;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _setController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.collapsed) return const SizedBox.shrink();

    _latitudeController.text = widget.latitude?.toStringAsFixed(6) ?? '';
    _longitudeController.text = widget.longitude?.toStringAsFixed(6) ?? '';

    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        radius: const Radius.circular(12),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Card(
            color: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Landmark Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      /*--------------------------------------------------+
                    | Campi del form                                    |
                    +--------------------------------------------------*/
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Name *",
                          hintText: "Enter landmark name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Enter landmark description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _setController,
                        decoration: InputDecoration(
                          labelText: "Set",
                          hintText: "Enter set name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _latitudeController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "Latitude *",
                          hintText: "Enter latitude",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Latitude is required";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _longitudeController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "Longitude *",
                          hintText: "Enter longitude",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Longitude is required";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      /*--------------------------------------------------+
                    | Riga con i bottoni                                |
                    +--------------------------------------------------*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _nameController.clear();
                              _descriptionController.clear();
                              _setController.clear();
                              _latitudeController.clear();
                              _longitudeController.clear();
                              _formKey.currentState?.reset();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final navigator = Navigator.of(context);
                                final messenger = ScaffoldMessenger.of(context);

                                try {
                                  if (widget.placeId != null) {
                                    // Aggiorna landmark esistente
                                    await _firestoreService.updatePlace(
                                      placeId: widget.placeId!,
                                      name: _nameController.text,
                                      description: _descriptionController.text,
                                      set: _setController.text,
                                      latitude: double.parse(
                                        _latitudeController.text,
                                      ),
                                      longitude: double.parse(
                                        _longitudeController.text,
                                      ),
                                    );

                                    if (!mounted) return;
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Landmark updated successfully!',
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 5),
                                      ),
                                    );

                                    // Navigate back to page 1
                                    navigator.pop();
                                  } else {
                                    // Aggiungi nuovo landmark
                                    await _firestoreService.addPlace(
                                      name: _nameController.text,
                                      description: _descriptionController.text,
                                      set: _setController.text,
                                      latitude: double.parse(
                                        _latitudeController.text,
                                      ),
                                      longitude: double.parse(
                                        _longitudeController.text,
                                      ),
                                    );

                                    // Clear form and show success message
                                    _nameController.clear();
                                    _descriptionController.clear();
                                    _setController.clear();
                                    _latitudeController.clear();
                                    _longitudeController.clear();
                                    _formKey.currentState?.reset();

                                    if (!mounted) return;
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Landmark added successfully!',
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 5),
                                      ),
                                    );

                                    // Navigate back to page 1
                                    navigator.pop();
                                  }
                                } catch (e) {
                                  if (!mounted) return;
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
