import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_spacing.dart';
import '../providers/templates_providers.dart';

class ApplyTemplateDialog extends ConsumerStatefulWidget {
  final ProgramTemplate template;

  const ApplyTemplateDialog({super.key, required this.template});

  @override
  ConsumerState<ApplyTemplateDialog> createState() =>
      _ApplyTemplateDialogState();
}

class _ApplyTemplateDialogState extends ConsumerState<ApplyTemplateDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Use Template: ${widget.template.name}'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.template.description != null) ...[
              Text(
                widget.template.description!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Program Name *',
                hintText: 'Name for the new program',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create Program'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSubmitting = true);
    final result =
        await ref.read(templateActionsProvider.notifier).apply(
              templateId: widget.template.id,
              programName: name,
              programDescription: _descController.text.trim().isEmpty
                  ? null
                  : _descController.text.trim(),
            );
    if (mounted) {
      Navigator.pop(context);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Created "${result.programName}" with ${result.workstreamsCreated} workstream(s)',
            ),
          ),
        );
        context.go('/programs/${result.programId}');
      }
    }
  }
}
