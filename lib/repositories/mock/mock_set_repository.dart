import 'package:gym_app/models/workout_set.dart';

import '../../mock_data/workout_sessions.dart';
import '../base/set_repository.dart';

class MockSetRepository implements SetRepository {

  final List<WorkoutSet> _sets = List.from(workoutSets);

  @override
  void addWorkoutSet(WorkoutSet set) {
    _sets.add(set);
  }

  @override
  List<WorkoutSet> getWorkoutSets() {
    return _sets;
  }
}