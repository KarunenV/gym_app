import 'package:flutter/material.dart';
import 'package:gym_app/models/workout_group.dart';
import '../repositories/base/exercise_repository.dart';
import 'workout_entry_page.dart';

class ExerciseListPage extends StatelessWidget {
  final WorkoutGroup workoutGroup;
  final ExerciseRepository repository;

  const ExerciseListPage({
    super.key,
    required this.workoutGroup,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final filteredExercises = repository.getExercisesByGroup(workoutGroup);

    return Scaffold(
      appBar: AppBar(
        title: Text('${_groupLabel(workoutGroup)} Exercises')        
      ),
      body: filteredExercises.isEmpty
          ? Center(
              child: Text(
                'No exercises found for ${_groupLabel(workoutGroup)}.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredExercises.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Text(exercise.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutEntryPage(
                            exercise: exercise,
                            repository: repository,
                          ),
                        ),
                      );
                      // Handle exercise tap, e.g., navigate to exercise details
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add exercise action coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
      },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _groupLabel(WorkoutGroup group) {
    final name = group.name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
