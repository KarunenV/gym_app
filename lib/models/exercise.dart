import 'package:cloud_firestore/cloud_firestore.dart';
import 'workout_group.dart';

class Exercise {
  final String id;
  final String name;
  final WorkoutGroup group;

  const Exercise({required this.id, required this.name, required this.group});

  Map<String, dynamic> toMap() => {'name': name, 'group': group.name};

  factory Exercise.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Exercise(
      id: doc.id,
      name: data['name'] as String,
      group: WorkoutGroup.values.byName(data['group'] as String),
    );
  }
}