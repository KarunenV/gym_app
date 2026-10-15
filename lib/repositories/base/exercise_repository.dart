import '../../models/exercise.dart';
import '../../models/workout_group.dart';

abstract class ExerciseRepository {
  Stream<List<Exercise>> watchByGroup(WorkoutGroup group);
  void add(Exercise exercise);
  void seedIfNeeded(List<Exercise> defaults);
}