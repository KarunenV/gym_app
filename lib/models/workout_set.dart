class WorkoutSet {
  static int _nextId = 0;

  final String id;
  int reps;
  double weight;

  WorkoutSet({String? id, required this.reps, required this.weight})
      : id = id ?? 'set_${_nextId++}';
}
