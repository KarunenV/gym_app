import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/models/workout_group.dart';

const exercises = [
  Exercise(
    id: 'bench_press',
    name: 'Bench Press',
    group: WorkoutGroup.upper,
  ),

  Exercise(
    id: 'incline_bench',
    name: 'Incline Bench',
    group: WorkoutGroup.upper,
  ),

  Exercise(
    id: 'shoulder_press',
    name: 'Shoulder Press',
    group: WorkoutGroup.upper,
  ),

  Exercise(
    id: 'lat_pulldown',
    name: 'Lat Pulldown',
    group: WorkoutGroup.upper,
  ),

  Exercise(
    id: 'squat',
    name: 'Squat',
    group: WorkoutGroup.lower,
  ),

  Exercise(
    id: 'deadlift',
    name: 'Deadlift',
    group: WorkoutGroup.lower,
  ),

  Exercise(
    id: 'leg_press',
    name: 'Leg Press',
    group: WorkoutGroup.lower,
  ),

  Exercise(
    id: 'lunges',
    name: 'Walking Lunges',
    group: WorkoutGroup.lower,
  ),

  Exercise(
    id: 'running',
    name: 'Running',
    group: WorkoutGroup.cardio,
  ),

  Exercise(
    id: 'cycling',
    name: 'Cycling',
    group: WorkoutGroup.cardio,
  ),

  Exercise(
    id: 'jump_rope',
    name: 'Jump Rope',
    group: WorkoutGroup.cardio,
  ),

  Exercise(
    id: 'burpees',
    name: 'Burpees',
    group: WorkoutGroup.cardio,
  ),
];