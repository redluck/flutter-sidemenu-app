import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/firestore_service.dart';

class LandmarksList extends StatefulWidget {
  final bool collapsed;
  final ScrollController scrollController;
  final void Function(num lat, num lon) onItemTap;

  const LandmarksList({
    super.key,
    required this.collapsed,
    required this.scrollController,
    required this.onItemTap,
  });

  @override
  State<LandmarksList> createState() => _LandmarksListState();
}

class _LandmarksListState extends State<LandmarksList> {
  late final ValueNotifier<String?> selectedPlaceName = ValueNotifier(null);

  @override
  void dispose() {
    selectedPlaceName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: widget.collapsed
            ? const SizedBox.shrink()
            : StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getPlaces(),
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
                    controller: widget.scrollController,
                    thumbVisibility: true,
                    radius: const Radius.circular(12),
                    child: ValueListenableBuilder<String?>(
                      valueListenable: selectedPlaceName,
                      builder: (context, selected, _) {
                        return ListView.builder(
                          controller: widget.scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final place = docs[index];
                            final placeName = place['name'] ?? '';
                            final isSelected = selected == placeName;

                            return _LandmarkListItem(
                              placeName: placeName,
                              description: place['description'] ?? '',
                              latitude: place['latitude'],
                              longitude: place['longitude'],
                              isSelected: isSelected,
                              onTap: () {
                                selectedPlaceName.value = placeName;
                                widget.onItemTap(
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

class _LandmarkListItem extends StatelessWidget {
  final String placeName;
  final String description;
  final num latitude;
  final num longitude;
  final bool isSelected;
  final VoidCallback onTap;

  const _LandmarkListItem({
    required this.placeName,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade400 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          title: Text(placeName),
          subtitle: Text(description),
        ),
      ),
    );
  }
}
