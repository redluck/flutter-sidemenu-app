import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/firestore_service.dart';

class LandmarksList extends StatelessWidget {
  final bool collapsed;
  final ScrollController scrollController;

  const LandmarksList({
    super.key,
    required this.collapsed,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: collapsed
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
                    controller: scrollController,
                    thumbVisibility: true,
                    radius: const Radius.circular(12),
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: docs.length,
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
                              subtitle: Text(place['description'] ?? ''),
                            ),
                          ),
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
