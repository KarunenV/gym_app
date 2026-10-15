import '../../models/exercise.dart';
import '../../models/workout_group.dart';


abstract class ExerciseRepository {
  List<Exercise> getExercises();

  List<Exercise> getExercisesByGroup(WorkoutGroup group);

  void addExercise(Exercise exercise);
}