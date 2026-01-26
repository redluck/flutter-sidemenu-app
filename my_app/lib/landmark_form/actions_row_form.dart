import 'package:flutter/material.dart';
import '../landmark_form/landmark_form.dart';

class ActionsRowForm extends StatelessWidget {
  final bool collapsed;
  final VoidCallback onOpenClosePressed;
  final VoidCallback onMyLocationPressed;

  const ActionsRowForm({
    super.key,
    required this.collapsed,
    required this.onOpenClosePressed,
    required this.onMyLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.my_location, color: Colors.green[700], size: 40),
          onPressed: onMyLocationPressed,
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            collapsed ? Icons.open_in_full : Icons.close_fullscreen,
            color: Colors.green[700],
            size: 40,
          ),
          tooltip: collapsed ? 'Espandi' : 'Riduci',
          onPressed: onOpenClosePressed,
        ),
      ],
    );
  }
}
