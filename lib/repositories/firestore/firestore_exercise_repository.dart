import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../models/exercise.dart';
import '../../models/workout_group.dart';
import '../base/exercise_repository.dart';

class FirestoreExerciseRepository implements ExerciseRepository {
  FirestoreExerciseRepository(this.householdId);
  final String householdId;

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('households')
      .doc(householdId)
      .collection('exercises');

  @override
  Stream<List<Exercise>> watchByGroup(WorkoutGroup group) {
    return _col.where('group', isEqualTo: group.name).snapshots().map((snap) {
      final list = snap.docs.map(Exercise.fromDoc).toList();
      list.sort((a, b) => a.name.compareTo(b.name)); // sorted here to avoid an index
      return list;
    });
  }

  @override
  String newId() => _col.doc().id; // generated locally, works offline

  @override
  void add(Exercise exercise) {
    // Not awaited: works offline. Failures are only logged.
    _col.doc(exercise.id).set(exercise.toMap()).catchError((Object e) {
      debugPrint('Exercise add failed: $e');
    });
  }
}