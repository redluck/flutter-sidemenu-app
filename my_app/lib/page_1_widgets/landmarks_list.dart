import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/firestore_service.dart';
import 'package:my_app/page_1_widgets/landmarks_list_item.dart';

class LandmarksList extends StatefulWidget {
  final bool collapsed;
  final ScrollController scrollController;
  final void Function(String id, num lat, num lon) onItemTap;

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
                            final isSelected = selected == place['name'];

                            return LandmarksListItem(
                              name: place['name'],
                              description: place['description'] ?? '',
                              latitude: place['latitude'],
                              longitude: place['longitude'],
                              isSelected: isSelected,
                              onTap: () {
                                selectedPlaceName.value = place['name'];
                                widget.onItemTap(
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
