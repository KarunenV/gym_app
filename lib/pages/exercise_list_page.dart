import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/profile.dart';
import '../models/workout_group.dart';
import '../repositories/base/exercise_repository.dart';
import '../repositories/base/session_repository.dart';
import '../widgets/add_exercise_dialog.dart';
import '../widgets/last_done_text.dart';
import 'workout_entry_page.dart';

class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({
    super.key,
    required this.workoutGroup,
    required this.profiles,
    required this.exerciseRepository,
    required this.sessionRepository,
  });

  final WorkoutGroup workoutGroup;
  final List<Profile> profiles;
  final ExerciseRepository exerciseRepository;
  final SessionRepository sessionRepository;

  String get _label =>
      workoutGroup.name[0].toUpperCase() + workoutGroup.name.substring(1);

  Future<void> _addExercise(
      BuildContext context, List<Exercise> existing) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AddExerciseDialog(
        groupLabel: _label,
        existingNames: existing.map((e) => e.name).toList(),
      ),
    );
    if (name == null) return;

    // The list updates by itself: the local write triggers the snapshot stream.
    exerciseRepository.add(
      Exercise(
        id: exerciseRepository.newId(),
        name: name,
        group: workoutGroup,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Exercise>>(
      stream: exerciseRepository.watchByGroup(workoutGroup),
      builder: (context, snap) {
        final exercises = snap.data ?? const <Exercise>[];

        Widget body;
        if (snap.hasError) {
          body = Center(child: Text('Error: ${snap.error}'));
        } else if (!snap.hasData) {
          body = const Center(child: CircularProgressIndicator());
        } else if (exercises.isEmpty) {
          body = Center(child: Text('No exercises found for $_label.'));
        } else {
          body = ListView.separated(
            // Bottom padding clears the FAB (~72) plus the system nav bar.
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + 72 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: exercises.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  title: Text(exercise.name),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: LastDoneText(
                      repository: sessionRepository,
                      profiles: profiles,
                      exerciseId: exercise.id,
                      style: const TextStyle(fontSize: 12),
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutEntryPage(
                        exercise: exercise,
                        profiles: profiles,
                        sessionRepository: sessionRepository,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text('$_label Exercises')),
          body: body,
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add exercise',
            onPressed: () => _addExercise(context, exercises),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}