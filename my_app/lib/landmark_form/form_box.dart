import 'package:flutter/material.dart';

class FormBox extends StatelessWidget {
  final bool collapsed;

  const FormBox({
    super.key,
    required this.collapsed,
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Form fields",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
