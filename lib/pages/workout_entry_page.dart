import 'dart:async';
import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/profile.dart';
import '../models/workout_session.dart';
import '../models/workout_set.dart';
import '../repositories/base/session_repository.dart';
import '../utils/format.dart';

class WorkoutEntryPage extends StatelessWidget {
  const WorkoutEntryPage({
    super.key,
    required this.exercise,
    required this.profiles,
    required this.sessionRepository,
  });

  final Exercise exercise;
  final List<Profile> profiles;
  final SessionRepository sessionRepository;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: profiles.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(exercise.name),
          bottom: TabBar(
            tabs: [for (final p in profiles) Tab(text: p.name)],
          ),
        ),
        body: TabBarView(
          children: [
            for (final p in profiles)
              _ProfileTab(
                key: ValueKey(p.id),
                exercise: exercise,
                profile: p,
                sessionRepository: sessionRepository,
              ),
          ],
        ),
      ),
    );
  }
}

/// One row of inputs. The text controllers are the source of truth.
class _SetRow {
  _SetRow(int reps, double weight)
      : reps = TextEditingController(text: reps.toString()),
        weight = TextEditingController(text: formatWeight(weight));

  final TextEditingController reps;
  final TextEditingController weight;

  int get repsValue => int.tryParse(reps.text) ?? 0;
  double get weightValue => double.tryParse(weight.text) ?? 0;

  void dispose() {
    reps.dispose();
    weight.dispose();
  }
}

class _ProfileTab extends StatefulWidget {
  const _ProfileTab({
    super.key,
    required this.exercise,
    required this.profile,
    required this.sessionRepository,
  });

  final Exercise exercise;
  final Profile profile;
  final SessionRepository sessionRepository;

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab>
    with AutomaticKeepAliveClientMixin {
  StreamSubscription<WorkoutSession?>? _sub;
  WorkoutSession? _previous;
  List<_SetRow> _rows = [_SetRow(0, 0)];
  bool _dirty = false; // true once the user has edited anything

  @override
  bool get wantKeepAlive => true; // keep typed values when switching tabs

  @override
  void initState() {
    super.initState();
    _sub = widget.sessionRepository
        .watchLatest(
          profileId: widget.profile.id,
          exerciseId: widget.exercise.id,
        )
        .listen((session) {
      if (!mounted) return;
      setState(() {
        _previous = session;
        if (!_dirty) {
          // Pre-fill today's sets from the last session.
          _replaceRows(session == null
              ? [_SetRow(0, 0)]
              : session.sets.map((s) => _SetRow(s.reps, s.weight)).toList());
        }
      });
    });
  }

  void _replaceRows(List<_SetRow> next) {
    final old = _rows;
    _rows = next;
    // Dispose after the frame so the old TextFields are gone first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final r in old) {
        r.dispose();
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  void _addSet() {
    setState(() {
      _dirty = true;
      final last = _rows.isEmpty ? null : _rows.last;
      _rows.add(_SetRow(last?.repsValue ?? 0, last?.weightValue ?? 0));
    });
  }

  void _removeSet(_SetRow row) {
    setState(() {
      _dirty = true;
      _rows.remove(row);
      WidgetsBinding.instance.addPostFrameCallback((_) => row.dispose());
    });
  }

  void _bumpReps(_SetRow row, int delta) {
    setState(() {
      _dirty = true;
      row.reps.text = (row.repsValue + delta).clamp(0, 1000).toString();
    });
  }

  void _bumpWeight(_SetRow row, double delta) {
    setState(() {
      _dirty = true;
      row.weight.text =
          formatWeight((row.weightValue + delta).clamp(0, 1000).toDouble());
    });
  }

  void _save() {
    final sets = _rows
        .map((r) => WorkoutSet(reps: r.repsValue, weight: r.weightValue))
        .where((s) => s.reps > 0 || s.weight > 0)
        .toList();

    if (sets.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing to save')));
      return;
    }

    widget.sessionRepository.save(
      WorkoutSession(
        id: widget.sessionRepository.newId(),
        exerciseId: widget.exercise.id,
        profileId: widget.profile.id,
        group: widget.exercise.group,
        date: DateTime.now(),
        sets: sets,
      ),
    );

    setState(() => _dirty = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved for ${widget.profile.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _previous == null
                ? 'Previous workout'
                : 'Previous workout · ${formatDate(_previous!.date)}',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (_previous == null)
            const Text('No previous workout')
          else
            for (final s in _previous!.sets)
              Text('${s.reps} reps × ${formatWeight(s.weight)} kg'),
          const Divider(height: 32),
          Text("Today's sets", style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _rows.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final row = _rows[i];
                return Row(
                  key: ObjectKey(row),
                  children: [
                    Expanded(
                      child: _Stepper(
                        label: 'Reps',
                        controller: row.reps,
                        onMinus: () => _bumpReps(row, -1),
                        onPlus: () => _bumpReps(row, 1),
                        onChanged: () => _dirty = true,
                        decimal: false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _Stepper(
                        label: 'Weight (kg)',
                        controller: row.weight,
                        onMinus: () => _bumpWeight(row, -2.5),
                        onPlus: () => _bumpWeight(row, 2.5),
                        onChanged: () => _dirty = true,
                        decimal: true,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeSet(row),
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete set',
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _addSet,
                icon: const Icon(Icons.add),
                label: const Text('Add set'),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.controller,
    required this.onMinus,
    required this.onPlus,
    required this.onChanged,
    required this.decimal,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onChanged;
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onMinus,
          icon: const Icon(Icons.remove),
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: decimal),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}