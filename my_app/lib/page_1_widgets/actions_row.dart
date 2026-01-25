import 'package:flutter/material.dart';

class ActionsRow extends StatelessWidget {
  final bool collapsed;
  final bool listIconVisible;
  final VoidCallback onOpenClosePressed;
  final VoidCallback onListPressed;
  final VoidCallback onMyLocationPressed;

  const ActionsRow({
    super.key,
    required this.collapsed,
    required this.listIconVisible,
    required this.onOpenClosePressed,
    required this.onListPressed,
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
        IconButton(
          icon: Icon(Icons.add_location, color: Colors.green[700], size: 40),
          onPressed: () {},
        ),
        const Spacer(),
        listIconVisible && !collapsed ? IconButton(
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
