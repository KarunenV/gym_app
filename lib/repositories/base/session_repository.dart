import '../../models/workout_session.dart';


abstract class SessionRepository {
  List<WorkoutSession> getWorkoutSessions();

  void addWorkoutSession(WorkoutSession session);
}