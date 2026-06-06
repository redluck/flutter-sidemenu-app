import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/firestore_service.dart';
import 'package:my_app/page_1_widgets/landmarks_list_item.dart';

class LandmarksList extends StatelessWidget {
  final bool collapsed;
  final ScrollController scrollController;
  final void Function(String id, num lat, num lon) onItemTap;
  final ValueNotifier<String> selectedPlaceIdNotifier;
  final String? selectedSet;

  const LandmarksList({
    super.key,
    required this.collapsed,
    required this.scrollController,
    required this.onItemTap,
    required this.selectedPlaceIdNotifier,
    this.selectedSet,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: collapsed
            ? const SizedBox.shrink()
            : StreamBuilder<QuerySnapshot>(
                stream: selectedSet != null
                    ? FirestoreService().getPlaces(selectedSet!)
                    : FirestoreService().getPlaces(null),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(child: Text('No places yet'));
                  }
                  return Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    radius: const Radius.circular(12),
                    child: ValueListenableBuilder<String>(
                      valueListenable: selectedPlaceIdNotifier,
                      builder: (context, selectedId, _) {
                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final place = docs[index];
                            final isSelected = selectedId == place.id;

                            return LandmarksListItem(
                              name: place['name'],
                              description: place['description'] ?? '',
                              latitude: place['latitude'],
                              longitude: place['longitude'],
                              isSelected: isSelected,
                              onTap: () {
                                onItemTap(
                                  place.id,
                                  place['latitude'],
                                  place['longitude'],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
