import 'package:cloud_firestore/cloud_firestore.dart';
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
  void add(Exercise exercise) {
    _col.doc(exercise.id).set(exercise.toMap()); // not awaited: works offline
  }

  // Temporary: uses fixed doc IDs, so running it twice is harmless.
  // Remove once the "add exercise" screen exists.
  @override
  void seedIfNeeded(List<Exercise> defaults) {
    final batch = FirebaseFirestore.instance.batch();
    for (final e in defaults) {
      batch.set(_col.doc(e.id), e.toMap(), SetOptions(merge: true));
    }
    batch.commit();
  }
}