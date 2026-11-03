import '../../models/exercise.dart';
import '../../models/workout_group.dart';

abstract class ExerciseRepository {
  Stream<List<Exercise>> watchByGroup(WorkoutGroup group);

  String newId();
  void add(Exercise exercise);
}