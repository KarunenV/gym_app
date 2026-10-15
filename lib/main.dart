import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'repositories/mock/mock_exercise_repository.dart';
import 'repositories/mock/mock_profile_repository.dart';

const String householdId = 'default_household';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const GymTrackerApp());
}

class GymTrackerApp extends StatefulWidget {
  const GymTrackerApp({super.key});

  @override
  State<GymTrackerApp> createState() => _GymTrackerAppState();
}

class _GymTrackerAppState extends State<GymTrackerApp> {
  // Created once, so ticking a box doesn't reset the data on rebuild.
  final _exerciseRepo = MockExerciseRepository();
  final _profileRepo = MockProfileRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Tracker',
      debugShowCheckedModeBanner: false,
      home: HomePage(
        exercisesRepository: _exerciseRepo,
        profileRepository: _profileRepo,
      ),
    );
  }
}