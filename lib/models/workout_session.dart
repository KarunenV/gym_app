class WorkoutSession {
  final String id;
  final String exerciseId;
  final String profileId;
  final DateTime date;
  final List<String> setIds;

  WorkoutSession({
    required this.id,
    required this.exerciseId,
    required this.profileId,
    required this.date,
    required this.setIds,
  });
}