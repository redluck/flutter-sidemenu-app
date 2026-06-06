import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPlaces(String? set) {
    Query query = _firestore.collection('places');
    if (set != null) {
      query = query.where('set', isEqualTo: set);
    }
    return query.snapshots();
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

  Future<void> deletePlace(String placeId) {
    return _firestore.collection('places').doc(placeId).delete();
  }

  Future<void> updatePlace({
    required String placeId,
    required String name,
    required double latitude,
    required double longitude,
    String? description,
    String? set,
  }) {
    return _firestore.collection('places').doc(placeId).update({
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'description': description ?? '',
      'set': set ?? '',
    });
  }
}
