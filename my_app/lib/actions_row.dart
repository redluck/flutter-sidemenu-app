import 'package:flutter/material.dart';

class ActionsRow extends StatelessWidget {
  final bool collapsed;
  final bool listIconVisible;
  final VoidCallback onOpenClosePressed;
  final VoidCallback onListPressed;

  const ActionsRow({
    super.key,
    required this.collapsed,
    required this.listIconVisible,
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
        listIconVisible ? IconButton(
          icon: Icon(Icons.list, color: Colors.green[700], size: 40),
          onPressed: onListPressed,
        ) : const SizedBox.shrink(),
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
