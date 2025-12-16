import 'package:flutter/material.dart';

class ActionsRow extends StatelessWidget {
  final bool collapsed;
  final VoidCallback onOpenClosePressed;
  final VoidCallback onListPressed;

  const ActionsRow({
    super.key,
    required this.collapsed,
    required this.onOpenClosePressed,
    required this.onListPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.my_location, color: Colors.green[700], size: 40),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.add_location, color: Colors.green[700], size: 40),
          onPressed: () {},
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.list, color: Colors.green[700], size: 40),
          onPressed: onListPressed,
        ),
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
