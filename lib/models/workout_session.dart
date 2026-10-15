import 'package:cloud_firestore/cloud_firestore.dart';
import 'workout_group.dart';
import 'workout_set.dart';

class WorkoutSession {
  final String id;
  final String exerciseId;
  final String profileId;
  final WorkoutGroup group;
  final DateTime date;
  final List<WorkoutSet> sets;

  WorkoutSession({
    required this.id,
    required this.exerciseId,
    required this.profileId,
    required this.group,
    required this.date,
    required this.sets,
  });

  Map<String, dynamic> toMap() => {
        'exerciseId': exerciseId,
        'profileId': profileId,
        'group': group.name,
        'date': Timestamp.fromDate(date),
        'sets': sets.map((s) => s.toMap()).toList(),
      };

  factory WorkoutSession.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return WorkoutSession(
      id: doc.id,
      exerciseId: data['exerciseId'] as String,
      profileId: data['profileId'] as String,
      group: WorkoutGroup.values.byName(data['group'] as String),
      date: (data['date'] as Timestamp).toDate(),
      sets: (data['sets'] as List)
          .map((s) => WorkoutSet.fromMap(Map<String, dynamic>.from(s)))
          .toList(),
    );
  }
}