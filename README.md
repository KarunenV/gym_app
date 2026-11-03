# Gym Tracker

A small Flutter app for logging gym workouts for a household of trainees.
Pick who is training, pick a workout group (upper / lower / cardio), pick an
exercise, and log sets (reps + weight in kg). The app shows each person's
"last done" date and pre-fills today's sets from their previous session.

Targets: Android, iOS, web. Backend: Firebase (Auth with Google, Cloud Firestore
with offline persistence).

## Setup

1. Install Flutter (Dart SDK ^3.12.2).
2. Create your own Firebase project and run `flutterfire configure`
   (this generates `lib/firebase_options.dart` and the platform config files).
3. Enable Google sign-in under Authentication, and create a Firestore database.
4. Deploy the rules in `firestore.rules`, with your own emails in the allow-list.
5. `flutter pub get` then `flutter run`.

## Structure

- `lib/models` – plain data classes
- `lib/repositories/base` – abstract repository interfaces
- `lib/repositories/firestore` – Firestore implementations
- `lib/repositories/mock` – in-memory implementations
- `lib/pages`, `lib/widgets` – UI