import 'package:flutter/material.dart';
import '../models/workout_group.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.isKarunen,
    required this.isAlice,
    required this.workoutGroup,
    required this.onTap,
  });

  final bool isKarunen;
  final bool isAlice;
  final WorkoutGroup? workoutGroup;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = _buildSubtitle();
    final displayColor = _getColor();
    final displayIcon = _getDefaultIcon();
    final displayLabel = _getDefaultLabel();

    final enabled = isKarunen || isAlice;

    return Opacity(
      opacity: enabled ? 1.0 : 0.65,
      child: Card(
        color: displayColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: (!enabled || workoutGroup == null) ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(displayIcon, size: 32),
                const SizedBox(height: 8),
                Text(
                  displayLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    if (!(isKarunen || isAlice)) {
      return Colors.grey.shade300;
    }

    switch (workoutGroup) {
      case WorkoutGroup.upper:
        return Colors.blue.shade100;
      case WorkoutGroup.lower:
        return Colors.green.shade100;
      case WorkoutGroup.cardio:
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  String _buildSubtitle() {
    final today = DateTime.now().toLocal();
    final dateText = '${today.day}/${today.month}/${today.year}';

    if (isKarunen && isAlice) {
      return 'Karunen Last workout: $dateText\n\nAlice Last workout: $dateText';
    }

    if (isKarunen) {
      return 'Karunen Last workout: $dateText';
    }

    if (isAlice) {
      return 'Alice Last workout: $dateText';
    }

    return 'No trainee selected';
  }

  IconData _getDefaultIcon() {
    switch (workoutGroup) {
      case WorkoutGroup.upper:
        return Icons.arrow_upward;
      case WorkoutGroup.lower:
        return Icons.arrow_downward;
      case WorkoutGroup.cardio:
        return Icons.directions_run;
      default:
        return Icons.fitness_center;
    }
  }

  String _getDefaultLabel() {
    switch (workoutGroup) {
      case WorkoutGroup.upper:
        return 'Upper';
      case WorkoutGroup.lower:
        return 'Lower';
      case WorkoutGroup.cardio:
        return 'Cardio';
      default:
        return 'Workout';
    }
  }
}