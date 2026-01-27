import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPlaces() {
    return _firestore.collection('places').snapshots();
  }

  Future<void> addPlace({
    required String name,
    required double latitude,
    required double longitude,
    String? description,
    String? set,
  }) {
    return _firestore.collection('places').add({
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'description': description ?? '',
      'set': set ?? '',
    });
  }
}
