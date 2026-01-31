import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/outcomes_providers.dart';

class CreateOutcomeDialog extends ConsumerStatefulWidget {
  const CreateOutcomeDialog({super.key});

  @override
  ConsumerState<CreateOutcomeDialog> createState() =>
      _CreateOutcomeDialogState();
}

class _CreateOutcomeDialogState extends ConsumerState<CreateOutcomeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  OutcomePriority _selectedPriority = OutcomePriority.MEDIUM;
  String? _selectedTeamId;
  DateTime? _targetDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(myTeamsProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
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
                    const Icon(Icons.flag_outlined, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text('New Outcome', style: AppTypography.h3),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: AppSpacing.md),

                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Outcome Title *',
                            hintText: 'What do you want to achieve?',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Title is required' : null,
                          autofocus: true,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Description
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Why is this outcome important?',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Priority and Team row
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<OutcomePriority>(
                                value: _selectedPriority,
                                decoration: const InputDecoration(
                                  labelText: 'Priority *',
                                  border: OutlineInputBorder(),
                                ),
                                items: OutcomePriority.values.map((p) {
                                  return DropdownMenuItem(
                                    value: p,
                                    child: Text(p.displayName),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedPriority = v!),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: teamsAsync.when(
                                data: (teams) =>
                                    DropdownButtonFormField<String>(
                                  value: _selectedTeamId,
                                  decoration: const InputDecoration(
                                    labelText: 'Owning Team *',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: teams.map((team) {
                                    return DropdownMenuItem(
                                      value: team.id,
                                      child: Text(team.name),
                                    );
                                  }).toList(),
                                  onChanged: (v) =>
                                      setState(() => _selectedTeamId = v),
                                  validator: (v) =>
                                      v == null ? 'Team is required' : null,
                                ),
                                loading: () => const LinearProgressIndicator(),
                                error: (e, _) => Text('Error: $e'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Target Date
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _targetDate ??
                                  DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              setState(() => _targetDate = date);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Target Date (Optional)',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              _targetDate != null
                                  ? '${_targetDate!.day}/${_targetDate!.month}/${_targetDate!.year}'
                                  : 'Select a date',
                              style: _targetDate == null
                                  ? TextStyle(color: AppColors.textTertiary)
                                  : null,
                            ),
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
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    currentUserAsync.when(
                      data: (user) => ElevatedButton(
                        onPressed: _isLoading ? null : () => _submit(user.id),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Create Outcome'),
                      ),
                      loading: () => const ElevatedButton(
                        onPressed: null,
                        child: Text('Create Outcome'),
                      ),
                      error: (_, __) => const ElevatedButton(
                        onPressed: null,
                        child: Text('Create Outcome'),
                      ),
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

  Future<void> _submit(String ownerId) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final createOutcome = ref.read(createOutcomeProvider.notifier);
      final outcome = await createOutcome.create(
        CreateOutcomeRequest(
          teamId: _selectedTeamId!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          priority: _selectedPriority,
          ownerId: ownerId,
          targetDate: _targetDate,
        ),
      );

      if (mounted && outcome != null) {
        Navigator.pop(context, outcome);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Outcome created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// Helper function to show the dialog
Future<Outcome?> showCreateOutcomeDialog(BuildContext context) {
  return showDialog<Outcome>(
    context: context,
    builder: (context) => const CreateOutcomeDialog(),
  );
}
