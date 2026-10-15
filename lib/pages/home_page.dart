import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/workout_group.dart';
import '../repositories/base/exercise_repository.dart';
import '../repositories/base/profile_repository.dart';
import '../repositories/base/session_repository.dart';
import '../widgets/workout_card.dart';
import 'exercise_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.exercisesRepository,
    required this.sessionRepository,
    required this.profileRepository,
  });

  final ExerciseRepository exercisesRepository;
  final SessionRepository sessionRepository;
  final ProfileRepository profileRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Row(
          children: [
            Icon(Icons.fitness_center),
            SizedBox(width: 8),
            Text('Gym Tracker'),
          ],
        ),
      ),
      body: HomeBody(
        exercisesRepository: exercisesRepository,
        sessionRepository: sessionRepository,
        profileRepository: profileRepository,
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
    required this.exercisesRepository,
    required this.sessionRepository,
    required this.profileRepository,
  });

  final ExerciseRepository exercisesRepository;
  final SessionRepository sessionRepository;
  final ProfileRepository profileRepository;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void _setProfileActive(Profile profile, bool isActive) {
    widget.profileRepository.updateProfile(
      Profile(id: profile.id, name: profile.name, isActive: isActive),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final profiles = widget.profileRepository.getProfiles();
    final active = profiles.where((p) => p.isActive).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who is training today?',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < profiles.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    CheckboxListTile(
                      title: Text(profiles[i].name),
                      value: profiles[i].isActive,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      onChanged: (v) => _setProfileActive(profiles[i], v ?? false),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Choose your workout',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            for (final group in WorkoutGroup.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: WorkoutCard(
                    profiles: active,
                    workoutGroup: group,
                    sessionRepository: widget.sessionRepository,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExerciseListPage(
                          workoutGroup: group,
                          profiles: active,
                          exerciseRepository: widget.exercisesRepository,
                          sessionRepository: widget.sessionRepository,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}