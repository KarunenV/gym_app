import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/workout_group.dart';
import '../models/workout_session.dart';
import '../repositories/base/session_repository.dart';
import '../utils/format.dart';

class LastDoneText extends StatelessWidget {
  const LastDoneText({
    super.key,
    required this.repository,
    required this.profiles,
    this.group,
    this.exerciseId,
    this.style,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final SessionRepository repository;
  final List<Profile> profiles;
  final WorkoutGroup? group;
  final String? exerciseId;
  final TextStyle? style;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final textAlign = crossAxisAlignment == CrossAxisAlignment.start
        ? TextAlign.start
        : TextAlign.center;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (final p in profiles)
          _LastDoneRow(
            key: ValueKey('${p.id}-${group?.name}-$exerciseId'),
            repository: repository,
            profile: p,
            group: group,
            exerciseId: exerciseId,
            style: style,
            textAlign: textAlign,
          ),
      ],
    );
  }
}

class _LastDoneRow extends StatefulWidget {
  const _LastDoneRow({
    super.key,
    required this.repository,
    required this.profile,
    required this.group,
    required this.exerciseId,
    required this.style,
    required this.textAlign,
  });

  final SessionRepository repository;
  final Profile profile;
  final WorkoutGroup? group;
  final String? exerciseId;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  State<_LastDoneRow> createState() => _LastDoneRowState();
}

class _LastDoneRowState extends State<_LastDoneRow> {
  late final Stream<WorkoutSession?> _stream = widget.repository.watchLatest(
    profileId: widget.profile.id,
    group: widget.group,
    exerciseId: widget.exerciseId,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WorkoutSession?>(
      stream: _stream,
      builder: (context, snap) {
        String text;
        if (snap.hasError) {
          debugPrint('LastDoneRow error: ${snap.error}'); // index link shows here
          text = '—';
        } else if (snap.connectionState == ConnectionState.waiting) {
          text = '…';
        } else {
          text = snap.data == null ? 'never' : formatDate(snap.data!.date);
        }
        return Text(
          '${widget.profile.name}: $text',
          textAlign: widget.textAlign,
          style: widget.style,
        );
      },
    );
  }
}