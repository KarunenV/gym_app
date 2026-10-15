import 'package:gym_app/models/workout_group.dart';

class Exercise {
  final String id;
  final String name;
  final WorkoutGroup group;

  const Exercise({
    required this.id,
    required this.name,
    required this.group,
  });
}