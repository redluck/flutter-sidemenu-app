import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../firestore_service.dart';

class DetailCard extends StatelessWidget {
  final bool collapsed;
  final String title;
  final String description;
  final String placeId;
  final double latitude;
  final double longitude;
  final VoidCallback onDelete;

  const DetailCard({
    super.key,
    required this.collapsed,
    required this.title,
    required this.description,
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.onDelete,
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
          child: Column(
            children: [
              Expanded(
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.map, color: Colors.green[700], size: 40),
                        onPressed: () async {
                          final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
                          try {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } catch (e) {
                            // Fallback per web o errori
                            await launchUrl(url);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green[700], size: 40),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.green[700], size: 40),
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text('Conferma eliminazione'),
                              content: Text('Vuoi eliminare "$title"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Annulla'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Elimina'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            try {
                              await FirestoreService().deletePlace(placeId);
                              
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Landmark eliminato con successo!'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 5),
                                ),
                              );
                              
                              onDelete();
                            } catch (e) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('Errore durante l\'eliminazione: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 5),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
