import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/workout_group.dart';
import '../repositories/base/session_repository.dart';
import 'last_done_text.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.profiles,
    required this.workoutGroup,
    required this.sessionRepository,
    required this.onTap,
  });

  final List<Profile> profiles; // the ticked people
  final WorkoutGroup workoutGroup;
  final SessionRepository sessionRepository;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = profiles.isNotEmpty;

    return Opacity(
      opacity: enabled ? 1.0 : 0.65,
      child: Card(
        color: _color(enabled),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_icon, size: 32),
                const SizedBox(height: 8),
                Text(_label, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                if (enabled)
                  LastDoneText(
                    repository: sessionRepository,
                    profiles: profiles,
                    group: workoutGroup,
                    style: const TextStyle(fontSize: 12),
                  )
                else
                  const Text('No trainee selected', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _color(bool enabled) {
    if (!enabled) return Colors.grey.shade300;
    switch (workoutGroup) {
      case WorkoutGroup.upper:
        return Colors.blue.shade100;
      case WorkoutGroup.lower:
        return Colors.green.shade100;
      case WorkoutGroup.cardio:
        return Colors.orange.shade100;
    }
  }

  IconData get _icon {
    switch (workoutGroup) {
      case WorkoutGroup.upper:
        return Icons.arrow_upward;
      case WorkoutGroup.lower:
        return Icons.arrow_downward;
      case WorkoutGroup.cardio:
        return Icons.directions_run;
    }
  }

  String get _label {
    final n = workoutGroup.name;
    return n[0].toUpperCase() + n.substring(1);
  }
}