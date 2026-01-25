import 'package:flutter/material.dart';

class LandmarksListItem extends StatelessWidget {
  final String name;
  final String description;
  final num latitude;
  final num longitude;
  final bool isSelected;
  final VoidCallback onTap;

  const LandmarksListItem({
    super.key,
    required this.name,
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
          title: Text(name),
          subtitle: Text(description),
        ),
      ),
    );
  }
}
