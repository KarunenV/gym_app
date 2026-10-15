import '../../mock_data/exercises.dart';
import '../../models/exercise.dart';
import '../../models/workout_group.dart';
import '../base/exercise_repository.dart';

class MockExerciseRepository implements ExerciseRepository {

  final List<Exercise> _exercises = List.from(exercises);

  @override
  List<Exercise> getExercises() {
    return _exercises;
  }

  @override
  List<Exercise> getExercisesByGroup(WorkoutGroup group) {
    return _exercises
        .where((e) => e.group == group)
        .toList();
  }

  @override
  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
  }
}