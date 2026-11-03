import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../models/workout_group.dart';
import '../../models/workout_session.dart';
import '../base/session_repository.dart';

class FirestoreSessionRepository implements SessionRepository {
  FirestoreSessionRepository(this.householdId);
  final String householdId;

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('households')
      .doc(householdId)
      .collection('sessions');

  @override
  Stream<WorkoutSession?> watchLatest({
    required String profileId,
    WorkoutGroup? group,
    String? exerciseId,
  }) {
    Query<Map<String, dynamic>> q = _col.where('profileId', isEqualTo: profileId);
    if (group != null) q = q.where('group', isEqualTo: group.name);
    if (exerciseId != null) q = q.where('exerciseId', isEqualTo: exerciseId);

    return q
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) =>
    snap.docs.isEmpty ? null : WorkoutSession.fromDoc(snap.docs.first));
  }

  @override
  String newId() => _col.doc().id;

  @override
  void save(WorkoutSession session) {
    // Not awaited: works offline. Failures are only logged.
    _col.doc(session.id).set(session.toMap()).catchError((Object e) {
      debugPrint('Session save failed: $e');
    });
  }
}