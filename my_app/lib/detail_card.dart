import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final bool collapsed;
  final ScrollController scrollController;
  final String title;
  final String description;

  const DetailCard({
    super.key,
    required this.collapsed,
    required this.scrollController,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    if (collapsed) return const SizedBox.shrink();

    return Expanded(
      child: Card(
        color: Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(description),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
