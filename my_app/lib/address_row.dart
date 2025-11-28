import 'package:flutter/material.dart';

class AddressRow extends StatelessWidget {
  const AddressRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4), // margin bottom
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Indirizzo o info',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Dettagli aggiuntivi qui',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  TextButton(onPressed: () {}, child: const Text('Azione')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
