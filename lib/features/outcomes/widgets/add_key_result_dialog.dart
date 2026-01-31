import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/outcomes_providers.dart';

class AddKeyResultDialog extends ConsumerStatefulWidget {
  final String outcomeId;
  final String outcomeTitle;

  const AddKeyResultDialog({
    super.key,
    required this.outcomeId,
    required this.outcomeTitle,
  });

  @override
  ConsumerState<AddKeyResultDialog> createState() => _AddKeyResultDialogState();
}

class _AddKeyResultDialogState extends ConsumerState<AddKeyResultDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _targetValueController = TextEditingController();
  final _currentValueController = TextEditingController(text: '0');
  final _unitController = TextEditingController();

  DateTime? _targetDate;
  bool _isLoading = false;

  static const _commonUnits = ['%', 'users', 'count', '\$', 'hours', 'days'];

  @override
  void dispose() {
    _descriptionController.dispose();
    _targetValueController.dispose();
    _currentValueController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(Icons.flag, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Add Key Result', style: AppTypography.h3),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'For: ${widget.outcomeTitle}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),

                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description *',
                            hintText: 'What will be measured?',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Description is required' : null,
                          autofocus: true,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Target and Current value row
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _targetValueController,
                                decoration: const InputDecoration(
                                  labelText: 'Target Value *',
                                  hintText: 'e.g., 100',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v?.isEmpty ?? true) {
                                    return 'Required';
                                  }
                                  if (double.tryParse(v!) == null) {
                                    return 'Invalid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _currentValueController,
                                decoration: const InputDecoration(
                                  labelText: 'Current Value',
                                  hintText: 'Starting value',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v?.isNotEmpty ?? false) {
                                    if (double.tryParse(v!) == null) {
                                      return 'Invalid number';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Unit
                        TextFormField(
                          controller: _unitController,
                          decoration: const InputDecoration(
                            labelText: 'Unit *',
                            hintText: 'e.g., %, users, \$',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Unit is required' : null,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: _commonUnits.map((unit) {
                            return ActionChip(
                              label: Text(unit),
                              onPressed: () =>
                                  setState(() => _unitController.text = unit),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Target date
                        Text('Target Date *', style: AppTypography.labelMedium),
                        const SizedBox(height: AppSpacing.xs),
                        InkWell(
                          onTap: _pickDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  _targetDate != null
                                      ? _formatDate(_targetDate!)
                                      : 'Select target date',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: _targetDate != null
                                        ? AppColors.textPrimary
                                        : AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_targetDate == null)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              'Target date is required',
                              style: AppTypography.bodySmall
                                  .copyWith(color: AppColors.error),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add Key Result'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_targetDate == null) return;

    setState(() => _isLoading = true);

    try {
      final addKeyResult = ref.read(addKeyResultProvider.notifier);
      final keyResult = await addKeyResult.add(
        widget.outcomeId,
        CreateKeyResultRequest(
          description: _descriptionController.text.trim(),
          targetValue: double.parse(_targetValueController.text.trim()),
          currentValue:
              double.tryParse(_currentValueController.text.trim()) ?? 0,
          unit: _unitController.text.trim(),
          targetDate: _targetDate!,
        ),
      );

      if (mounted && keyResult != null) {
        Navigator.pop(context, keyResult);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Key result added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// Helper function to show the dialog
Future<KeyResult?> showAddKeyResultDialog(
  BuildContext context, {
  required String outcomeId,
  required String outcomeTitle,
}) {
  return showDialog<KeyResult>(
    context: context,
    builder: (context) =>
        AddKeyResultDialog(outcomeId: outcomeId, outcomeTitle: outcomeTitle),
  );
}
