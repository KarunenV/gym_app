class WorkoutSet {
  int reps;
  double weight;

  WorkoutSet({required this.reps, required this.weight});

  Map<String, dynamic> toMap() => {'reps': reps, 'weight': weight};

  factory WorkoutSet.fromMap(Map<String, dynamic> map) => WorkoutSet(
        reps: (map['reps'] as num).toInt(),
        weight: (map['weight'] as num).toDouble(),
      );
}