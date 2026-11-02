import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/profile.dart';
import '../models/workout_group.dart';
import '../repositories/base/exercise_repository.dart';
import '../repositories/base/session_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$_label Exercises')),
      body: StreamBuilder<List<Exercise>>(
        stream: exerciseRepository.watchByGroup(workoutGroup),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final exercises = snap.data!;
          if (exercises.isEmpty) {
            return Center(child: Text('No exercises found for $_label.'));
          }
          return ListView.separated(
            // Bottom padding clears the FAB (~72) plus the system nav bar.
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + 72 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: exercises.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add exercise coming soon')),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}