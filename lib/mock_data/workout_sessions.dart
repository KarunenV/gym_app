import 'package:gym_app/mock_data/exercises.dart';
import 'package:gym_app/mock_data/profiles.dart';
import 'package:gym_app/models/workout_session.dart';
import 'package:gym_app/models/workout_set.dart';

List<WorkoutSet> _buildWorkoutSets() {
  final sets = <WorkoutSet>[];

  for (var index = 0; index < exercises.length; index++) {
    for (var setIndex = 0; setIndex < 3; setIndex++) {
      final setId = 'set_${index + 1}_${setIndex + 1}';
      sets.add(
        WorkoutSet(
          id: setId,
          reps: 8 + (index % 2) + setIndex,
          weight: 45.0 + index * 5.0 + setIndex * 2.5,
        ),
      );
    }
  }

  return sets;
}

List<WorkoutSession> _buildWorkoutSessions(List<WorkoutSet> sets) {
  final sessions = <WorkoutSession>[];

  for (var index = 0; index < exercises.length; index++) {
    final sessionSetIds = <String>[];

    for (var setIndex = 0; setIndex < 3; setIndex++) {
      final setId = 'set_${index + 1}_${setIndex + 1}';
      sessionSetIds.add(setId);
    }

    sessions.add(
      WorkoutSession(
        id: '${exercises[index].id}_session_${index + 1}',
        exerciseId: exercises[index].id,
        profileId: profiles[index % profiles.length].id,
        date: DateTime(2026, 7, index + 1, 8 + (index % 3), 30),
        setIds: sessionSetIds,
      ),
    );
  }

  return sessions;
}

final workoutSets = _buildWorkoutSets();
final workoutSessions = _buildWorkoutSessions(workoutSets);
