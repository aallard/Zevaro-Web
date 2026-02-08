import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/templates_providers.dart';

class CreateTemplateDialog extends ConsumerStatefulWidget {
  const CreateTemplateDialog({super.key});

  @override
  ConsumerState<CreateTemplateDialog> createState() =>
      _CreateTemplateDialogState();
}

class _CreateTemplateDialogState extends ConsumerState<CreateTemplateDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _structureController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _structureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Template'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Template Name *',
                hintText: 'e.g. Agile Development',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'What this template creates...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _structureController,
              decoration: InputDecoration(
                labelText: 'Structure (JSON) *',
                hintText:
                    '{"workstreams": [{"name": "Design"}, {"name": "Engineering"}]}',
                border: const OutlineInputBorder(),
                helperText: 'JSON defining the program structure',
                helperStyle:
                    AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
              ),
              maxLines: 4,
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
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final structure = _structureController.text.trim();
    if (name.isEmpty || structure.isEmpty) return;

    setState(() => _isSubmitting = true);
    await ref.read(templateActionsProvider.notifier).create(
          name: name,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          structure: structure,
        );
    if (mounted) Navigator.pop(context);
  }
}
