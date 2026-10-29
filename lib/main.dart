import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'mock_data/exercises.dart';
import 'pages/home_page.dart';
import 'repositories/firestore/firestore_exercise_repository.dart';
import 'repositories/firestore/firestore_session_repository.dart';
import 'repositories/mock/mock_profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String householdId = 'default_household';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (FirebaseAuth.instance.currentUser == null) {
  try {
    await FirebaseAuth.instance.signInAnonymously();
  } catch (e) {
    debugPrint('Auth failed: $e');
  }
}

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
  final _exerciseRepo = FirestoreExerciseRepository(householdId);
  final _sessionRepo = FirestoreSessionRepository(householdId);
  final _profileRepo = MockProfileRepository();

  @override
  void initState() {
    super.initState();
    _exerciseRepo.seedIfNeeded(exercises); // temporary, until "add exercise" exists
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Tracker',
      debugShowCheckedModeBanner: false,
      home: HomePage(
        exercisesRepository: _exerciseRepo,
        sessionRepository: _sessionRepo,
        profileRepository: _profileRepo,
      ),
    );
  }
}