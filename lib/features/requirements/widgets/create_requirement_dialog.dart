import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/requirements_providers.dart';

class CreateRequirementDialog extends ConsumerStatefulWidget {
  final String specificationId;

  const CreateRequirementDialog({super.key, required this.specificationId});

  @override
  ConsumerState<CreateRequirementDialog> createState() =>
      _CreateRequirementDialogState();
}

class _CreateRequirementDialogState
    extends ConsumerState<CreateRequirementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _acceptanceCriteriaController = TextEditingController();
  RequirementType _type = RequirementType.FUNCTIONAL;
  RequirementPriority _priority = RequirementPriority.MUST_HAVE;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _acceptanceCriteriaController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final requirement =
        await ref.read(createRequirementActionProvider.notifier).create(
              widget.specificationId,
              CreateRequirementRequest(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                type: _type,
                priority: _priority,
                acceptanceCriteria:
                    _acceptanceCriteriaController.text.trim().isEmpty
                        ? null
                        : _acceptanceCriteriaController.text.trim(),
              ),
            );

    if (requirement != null && mounted) {
      Navigator.pop(context);
      context.go(Routes.requirementById(requirement.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createRequirementActionProvider);
    final isLoading = createState.isLoading;

    return AlertDialog(
      title: const Text('Create Requirement'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g., User can reset password via email',
                  ),
                  autofocus: true,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Detailed description of the requirement',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<RequirementType>(
                        value: _type,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                        ),
                        items: RequirementType.values.map((t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Text(_typeLabel(t)),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _type = v);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<RequirementPriority>(
                        value: _priority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                        ),
                        items: RequirementPriority.values.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(_priorityLabel(p)),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _priority = v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _acceptanceCriteriaController,
                  decoration: const InputDecoration(
                    labelText: 'Acceptance Criteria (optional)',
                    hintText: 'Given... When... Then...',
                  ),
                  maxLines: 3,
                ),
                if (createState.hasError) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    createState.error.toString(),
                    style: TextStyle(color: AppColors.error, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: isLoading ? null : _submit,
          child: isLoading
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

  String _typeLabel(RequirementType type) {
    switch (type) {
      case RequirementType.FUNCTIONAL:
        return 'Functional';
      case RequirementType.NON_FUNCTIONAL:
        return 'Non-Functional';
      case RequirementType.CONSTRAINT:
        return 'Constraint';
      case RequirementType.INTERFACE:
        return 'Interface';
    }
  }

  String _priorityLabel(RequirementPriority priority) {
    switch (priority) {
      case RequirementPriority.MUST_HAVE:
        return 'Must Have';
      case RequirementPriority.SHOULD_HAVE:
        return 'Should Have';
      case RequirementPriority.COULD_HAVE:
        return 'Could Have';
      case RequirementPriority.WONT_HAVE:
        return "Won't Have";
    }
  }
}
