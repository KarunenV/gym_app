import '../../models/workout_set.dart';


abstract class SetRepository {
  List<WorkoutSet> getWorkoutSets();


  void addWorkoutSet(WorkoutSet set);
}