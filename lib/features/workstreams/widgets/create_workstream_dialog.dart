import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/workstreams_providers.dart';

class CreateWorkstreamDialog extends ConsumerStatefulWidget {
  final String programId;

  const CreateWorkstreamDialog({super.key, required this.programId});

  @override
  ConsumerState<CreateWorkstreamDialog> createState() =>
      _CreateWorkstreamDialogState();
}

class _CreateWorkstreamDialogState
    extends ConsumerState<CreateWorkstreamDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  WorkstreamMode _mode = WorkstreamMode.BUILD;
  ExecutionMode _executionMode = ExecutionMode.TRADITIONAL;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final workstream =
        await ref.read(createWorkstreamActionProvider.notifier).create(
              widget.programId,
              CreateWorkstreamRequest(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                mode: _mode,
                executionMode: _executionMode,
              ),
            );

    if (workstream != null && mounted) {
      Navigator.pop(context);
      context.go(Routes.workstreamById(workstream.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createWorkstreamActionProvider);
    final isLoading = createState.isLoading;

    return AlertDialog(
      title: const Text('Create Workstream'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Workstream Name',
                  hintText: 'e.g., User Authentication Build',
                ),
                autofocus: true,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief description of the workstream',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<WorkstreamMode>(
                value: _mode,
                decoration: const InputDecoration(
                  labelText: 'Mode',
                ),
                items: WorkstreamMode.values.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(_modeLabel(m)),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _mode = v);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<ExecutionMode>(
                value: _executionMode,
                decoration: const InputDecoration(
                  labelText: 'Execution Mode',
                ),
                items: ExecutionMode.values.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(_executionModeLabel(m)),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _executionMode = v);
                },
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

  String _modeLabel(WorkstreamMode mode) {
    switch (mode) {
      case WorkstreamMode.DISCOVERY:
        return 'Discovery';
      case WorkstreamMode.BUILD:
        return 'Build';
      case WorkstreamMode.OPS:
        return 'Ops';
    }
  }

  String _executionModeLabel(ExecutionMode mode) {
    switch (mode) {
      case ExecutionMode.AI_FIRST:
        return 'AI First';
      case ExecutionMode.TRADITIONAL:
        return 'Traditional';
      case ExecutionMode.HYBRID:
        return 'Hybrid';
    }
  }
}
