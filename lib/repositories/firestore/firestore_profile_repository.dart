import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/profile.dart';
import '../base/profile_repository.dart';

class FirestoreProfileRepository implements ProfileRepository {
  FirestoreProfileRepository(this.householdId);
  final String householdId;

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('households')
      .doc(householdId)
      .collection('profiles');

  @override
  Stream<List<Profile>> watchProfiles() {
    return _col.snapshots().map((snap) {
      final list = snap.docs.map(Profile.fromDoc).toList();
      list.sort((a, b) => a.name.compareTo(b.name)); // sorted here to avoid an index
      return list;
    });
  }

  @override
  void setActive(String id, bool isActive) {
    // not awaited: works offline
    _col.doc(id).set({'isActive': isActive}, SetOptions(merge: true));
  }
}