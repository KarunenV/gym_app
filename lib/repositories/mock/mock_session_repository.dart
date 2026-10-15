import 'package:gym_app/models/workout_session.dart';

import '../../mock_data/workout_sessions.dart';
import '../base/session_repository.dart';

class MockSessionRepository implements SessionRepository {

  final List<WorkoutSession> _sessions = List.from(workoutSessions);
 

  @override
  void addWorkoutSession(WorkoutSession session) {
    _sessions.add(session);
  }

  @override
  List<WorkoutSession> getWorkoutSessions() {
    return _sessions;
  }
}