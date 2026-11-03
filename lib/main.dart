import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'mock_data/exercises.dart';
import 'models/auth_user.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'repositories/firebase/firebase_auth_repository.dart';
import 'repositories/firestore/firestore_exercise_repository.dart';
import 'repositories/firestore/firestore_session_repository.dart';
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
  final _authRepo = FirebaseAuthRepository();
  final _exerciseRepo = FirestoreExerciseRepository(householdId);
  final _sessionRepo = FirestoreSessionRepository(householdId);
  final _profileRepo = MockProfileRepository();

  StreamSubscription<AuthUser?>? _authSub;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    // Temporary, until "add exercise" exists. Must run after sign-in,
    // otherwise the Firestore rules reject the write.
    _authSub = _authRepo.authStateChanges().listen((user) {
      if (user != null && !_seeded) {
        _seeded = true;
        _exerciseRepo.seedIfNeeded(exercises);
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Tracker',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<AuthUser?>(
        stream: _authRepo.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snap.data == null) {
            return LoginPage(authRepository: _authRepo);
          }
          return HomePage(
            exercisesRepository: _exerciseRepo,
            sessionRepository: _sessionRepo,
            profileRepository: _profileRepo,
            onSignOut: _authRepo.signOut,
          );
        },
      ),
    );
  }
}