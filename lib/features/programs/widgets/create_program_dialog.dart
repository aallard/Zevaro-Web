import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/programs_providers.dart';

class CreateProgramDialog extends ConsumerStatefulWidget {
  const CreateProgramDialog({super.key});

  @override
  ConsumerState<CreateProgramDialog> createState() =>
      _CreateProgramDialogState();
}

class _CreateProgramDialogState extends ConsumerState<CreateProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedColor;

  static const _programColors = [
    '#4F46E5', // Indigo
    '#10B981', // Emerald
    '#F59E0B', // Amber
    '#EF4444', // Rose
    '#06B6D4', // Cyan
    '#8B5CF6', // Purple
    '#EC4899', // Pink
    '#14B8A6', // Teal
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final program = await ref.read(createProgramProvider.notifier).create(
          CreateProgramRequest(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            color: _selectedColor ?? _programColors[0],
          ),
        );

    if (program != null && mounted) {
      ref.read(selectedProgramIdProvider.notifier).select(program.id);
      Navigator.pop(context);
      context.go(Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createProgramProvider);
    final isLoading = createState.isLoading;

    return AlertDialog(
      title: const Text('Create Program'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Program Name',
                  hintText: 'e.g., Mobile App Redesign',
                ),
                autofocus: true,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief description of the program',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.md),

              // Color picker
              Text('Color', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                children: _programColors.map((hex) {
                  final color = Color(
                      int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
                  final isSelected = _selectedColor == hex;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = hex),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.5),
                                  blurRadius: 6,
                                )
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 16)
                          : null,
                    ),
                  );
                }).toList(),
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
