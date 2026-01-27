import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final bool collapsed;
  final String title;
  final String description;

  const DetailCard({
    super.key,
    required this.collapsed,
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
        margin: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.map, color: Colors.green[700], size: 40),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green[700], size: 40),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.green[700], size: 40),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
