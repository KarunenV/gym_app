import '../../models/workout_group.dart';
import '../../models/workout_session.dart';

abstract class SessionRepository {
  /// Latest session for a person, optionally narrowed by group or exercise.
  Stream<WorkoutSession?> watchLatest({
    required String profileId,
    WorkoutGroup? group,
    String? exerciseId,
  });

  String newId();
  void save(WorkoutSession session);
}