import 'package:flutter/material.dart';

/// Asks for an exercise name. Pops with the trimmed name, or null if cancelled.
class AddExerciseDialog extends StatefulWidget {
  const AddExerciseDialog({
    super.key,
    required this.groupLabel,
    required this.existingNames,
  });

  final String groupLabel;
  final List<String> existingNames;

  @override
  State<AddExerciseDialog> createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter a name');
      return;
    }
    final exists = widget.existingNames
        .any((n) => n.toLowerCase() == name.toLowerCase());
    if (exists) {
      setState(() => _error = 'Already in ${widget.groupLabel}');
      return;
    }
    Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ${widget.groupLabel} exercise'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: 'Exercise name',
          errorText: _error,
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}