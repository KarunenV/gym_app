import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_set.dart';
import '../repositories/base/exercise_repository.dart';

class WorkoutEntryPage extends StatefulWidget {
  final Exercise exercise;
  final ExerciseRepository repository;  

  const WorkoutEntryPage({
    super.key,
    required this.exercise,
    required this.repository,
  });

  @override
  State<WorkoutEntryPage> createState() => _WorkoutEntryPageState();
}

class _WorkoutEntryPageState extends State<WorkoutEntryPage> {
  late final List<WorkoutSet> previousWorkout;
  late List<WorkoutSet> currentWorkout;
  late List<TextEditingController> repsControllers;
  late List<TextEditingController> weightControllers;
  int? _pendingDeleteIndex;

  @override
  void initState() {
    super.initState();

    previousWorkout = [
      WorkoutSet(reps: 10, weight: 30),
      WorkoutSet(reps: 10, weight: 35),
      WorkoutSet(reps: 8, weight: 40),
    ];

    currentWorkout = previousWorkout
        .map((set) => WorkoutSet(reps: set.reps, weight: set.weight))
        .toList();

    repsControllers = currentWorkout
        .map((set) => TextEditingController(text: set.reps.toString()))
        .toList();

    weightControllers = currentWorkout
        .map((set) => TextEditingController(text: set.weight.toString()))
        .toList();
  }

  @override
  void dispose() {
    for (final controller in repsControllers) {
      controller.dispose();
    }
    for (final controller in weightControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSet() {
    setState(() {
      final lastSet = currentWorkout.isEmpty
          ? WorkoutSet(reps: 0, weight: 0)
          : currentWorkout.last;

      final newSet = WorkoutSet(
        reps: lastSet.reps,
        weight: lastSet.weight,
      );

      currentWorkout.add(newSet);
      repsControllers.add(TextEditingController(text: newSet.reps.toString()));
      weightControllers.add(TextEditingController(text: newSet.weight.toString()));
    });
  }

  Future<void> _removeSet(int index) async {
    if (index < 0 || index >= currentWorkout.length) {
      return;
    }

    setState(() {
      _pendingDeleteIndex = index;
    });

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete set?'),
          content: const Text('Are you sure you want to delete this set?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _pendingDeleteIndex = null;
    });

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      currentWorkout.removeAt(index);
      repsControllers[index].dispose();
      repsControllers.removeAt(index);
      weightControllers[index].dispose();
      weightControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Entry - ${widget.exercise.name}'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Workout saved!')),
              );
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save),
            tooltip: 'Save workout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Previous Workout',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            ...previousWorkout.map(
              (set) => Text('Reps: ${set.reps}, Weight: ${set.weight} kg'),
            ),
            const SizedBox(height: 24),
            Text(
              'Current Workout',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: currentWorkout.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final set = currentWorkout[index];
                  final isPendingDelete = index == _pendingDeleteIndex;

                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isPendingDelete ? Colors.red.shade50 : null,
                      borderRadius: BorderRadius.circular(12),
                      border: isPendingDelete
                          ? Border.all(color: Colors.red.shade300)
                          : null,
                    ),
                    child: Row(
                      children: [
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  set.reps = (set.reps - 1).clamp(0, 1000);
                                  repsControllers[index].text = set.reps.toString();
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Expanded(
                              child: TextField(
                                controller: repsControllers[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  labelText: 'Reps',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  final parsedValue = int.tryParse(value);
                                  if (parsedValue != null) {
                                    setState(() {
                                      set.reps = parsedValue;
                                    });
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  set.reps = (set.reps + 1).clamp(0, 1000);
                                  repsControllers[index].text = set.reps.toString();
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  set.weight = (set.weight - 5).clamp(0, 1000);
                                  weightControllers[index].text = set.weight.toString();
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Expanded(
                              child: TextField(
                                controller: weightControllers[index],
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  labelText: 'Weight',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  final parsedValue = double.tryParse(value);
                                  if (parsedValue != null) {
                                    setState(() {
                                      set.weight = parsedValue;
                                    });
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  set.weight = (set.weight + 5).clamp(0, 1000);
                                  weightControllers[index].text = set.weight.toString();
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _removeSet(index),
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete set',
                      ),
                    ],
                  ));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSet,
        child: const Icon(Icons.add),
      ),
    );
  }
}