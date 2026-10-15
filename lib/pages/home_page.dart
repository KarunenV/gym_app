import 'package:flutter/material.dart';
import 'package:gym_app/widgets/workout_card.dart';
import '../models/profile.dart';
import '../models/workout_group.dart';
import '../repositories/base/exercise_repository.dart';
import '../pages/exercise_list_page.dart';
import '../repositories/base/profile_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.exercisesRepository, required this.profileRepository});

  final ExerciseRepository exercisesRepository;
  final ProfileRepository profileRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            const Icon(Icons.fitness_center, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Gym Tracker'),
          ],
        ),
      ),
      body: Center(child: HomeBody(exercisesRepository: exercisesRepository, profileRepository: profileRepository)),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key, required this.exercisesRepository, required this.profileRepository});

  final ExerciseRepository exercisesRepository;
  final ProfileRepository profileRepository;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void _setProfileActive(String id, bool isActive) {
    final profile = widget.profileRepository.getProfileById(id);
    widget.profileRepository.updateProfile(
      Profile(
        id: profile.id,
        name: profile.name,
        isActive: isActive,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final karunenProfile = widget.profileRepository.getProfileById('karunen');
    final aliceProfile = widget.profileRepository.getProfileById('alice');

    final workoutCards = [
      WorkoutCard(
        isKarunen: karunenProfile.isActive,
        isAlice: aliceProfile.isActive,
        workoutGroup: WorkoutGroup.upper,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseListPage(
                workoutGroup: WorkoutGroup.upper,
                repository: widget.exercisesRepository,
              ),
            ),
          );
        },
      ),
      WorkoutCard(
        isKarunen: karunenProfile.isActive,
        isAlice: aliceProfile.isActive,
        workoutGroup: WorkoutGroup.lower,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseListPage(
                workoutGroup: WorkoutGroup.lower,
                repository: widget.exercisesRepository,
              ),
            ),
          );
        },
      ),
      WorkoutCard(
        isKarunen: karunenProfile.isActive,
        isAlice: aliceProfile.isActive,
        workoutGroup: WorkoutGroup.cardio,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseListPage(
                workoutGroup: WorkoutGroup.cardio,
                repository: widget.exercisesRepository,
              ),
            ),
          );
        },
      ),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who is training today?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: Text(karunenProfile.name),
                    value: karunenProfile.isActive,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    onChanged: (bool? value) {
                      _setProfileActive(karunenProfile.id, value ?? false);
                    },
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    title: Text(aliceProfile.name),
                    value: aliceProfile.isActive,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    onChanged: (bool? value) {
                      _setProfileActive(aliceProfile.id, value ?? false);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Choose your workout',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    for (final card in workoutCards)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: card,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
