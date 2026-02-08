import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/specifications_providers.dart';

class CreateSpecificationDialog extends ConsumerStatefulWidget {
  final String workstreamId;

  const CreateSpecificationDialog({super.key, required this.workstreamId});

  @override
  ConsumerState<CreateSpecificationDialog> createState() =>
      _CreateSpecificationDialogState();
}

class _CreateSpecificationDialogState
    extends ConsumerState<CreateSpecificationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedHoursController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _estimatedHoursController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final estimatedHours = _estimatedHoursController.text.trim().isNotEmpty
        ? double.tryParse(_estimatedHoursController.text.trim())
        : null;

    final specification =
        await ref.read(createSpecificationActionProvider.notifier).create(
              widget.workstreamId,
              CreateSpecificationRequest(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                estimatedHours: estimatedHours,
              ),
            );

    if (specification != null && mounted) {
      Navigator.pop(context);
      context.go(Routes.specificationById(specification.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createSpecificationActionProvider);
    final isLoading = createState.isLoading;

    return AlertDialog(
      title: const Text('Create Specification'),
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
                  labelText: 'Specification Name',
                  hintText: 'e.g., User Login API',
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
                  hintText: 'What does this specification cover?',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _estimatedHoursController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Hours (optional)',
                  hintText: 'e.g., 40',
                ),
                keyboardType: TextInputType.number,
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
}
