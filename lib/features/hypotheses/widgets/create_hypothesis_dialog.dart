import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/hypotheses_providers.dart';

class CreateHypothesisDialog extends ConsumerStatefulWidget {
  final String? outcomeId;

  const CreateHypothesisDialog({super.key, this.outcomeId});

  @override
  ConsumerState<CreateHypothesisDialog> createState() =>
      _CreateHypothesisDialogState();
}

class _CreateHypothesisDialogState
    extends ConsumerState<CreateHypothesisDialog> {
  final _formKey = GlobalKey<FormState>();
  final _statementController = TextEditingController();
  final _descriptionController = TextEditingController();

  HypothesisConfidence _confidence = HypothesisConfidence.MEDIUM;
  String _effort = 'M';
  String _impact = 'MEDIUM';
  String? _selectedOutcomeId;
  bool _isLoading = false;

  static const _effortValues = ['XS', 'S', 'M', 'L', 'XL'];
  static const _impactValues = ['LOW', 'MEDIUM', 'HIGH'];

  @override
  void initState() {
    super.initState();
    _selectedOutcomeId = widget.outcomeId;
  }

  @override
  void dispose() {
    _statementController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outcomesAsync = ref.watch(myOutcomesProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
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
                    const Icon(Icons.science_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text('New Hypothesis', style: AppTypography.h3),
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
                        // Statement
                        TextFormField(
                          controller: _statementController,
                          decoration: const InputDecoration(
                            labelText: 'Hypothesis Statement *',
                            hintText:
                                'We believe that [action] will result in [outcome]...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          validator: (v) => v?.isEmpty ?? true
                              ? 'Statement is required'
                              : null,
                          autofocus: true,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Description
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Details & Rationale',
                            hintText: 'What evidence supports this hypothesis?',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Outcome selection
                        outcomesAsync.when(
                          data: (outcomes) => DropdownButtonFormField<String>(
                            value: _selectedOutcomeId,
                            decoration: const InputDecoration(
                              labelText: 'Parent Outcome *',
                              border: OutlineInputBorder(),
                            ),
                            items: outcomes.map((o) {
                              return DropdownMenuItem(
                                value: o.id,
                                child: Text(o.title,
                                    overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (v) =>
                                setState(() => _selectedOutcomeId = v),
                            validator: (v) =>
                                v == null ? 'Outcome is required' : null,
                          ),
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('Error: $e'),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Confidence
                        DropdownButtonFormField<HypothesisConfidence>(
                          value: _confidence,
                          decoration: const InputDecoration(
                            labelText: 'Confidence Level *',
                            border: OutlineInputBorder(),
                          ),
                          items: HypothesisConfidence.values.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(c.displayName),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() => _confidence = v!),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Effort / Impact
                        Text('Sizing', style: AppTypography.labelMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Effort',
                                      style: AppTypography.labelSmall),
                                  const SizedBox(height: AppSpacing.xs),
                                  SegmentedButton<String>(
                                    segments: _effortValues.map((s) {
                                      return ButtonSegment(
                                        value: s,
                                        label: Text(s),
                                      );
                                    }).toList(),
                                    selected: {_effort},
                                    onSelectionChanged: (s) =>
                                        setState(() => _effort = s.first),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Impact',
                                      style: AppTypography.labelSmall),
                                  const SizedBox(height: AppSpacing.xs),
                                  SegmentedButton<String>(
                                    segments: _impactValues.map((s) {
                                      return ButtonSegment(
                                        value: s,
                                        label: Text(s),
                                      );
                                    }).toList(),
                                    selected: {_impact},
                                    onSelectionChanged: (s) =>
                                        setState(() => _impact = s.first),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                            : const Text('Create Hypothesis'),
                      ),
                      loading: () => const ElevatedButton(
                        onPressed: null,
                        child: Text('Create Hypothesis'),
                      ),
                      error: (_, __) => const ElevatedButton(
                        onPressed: null,
                        child: Text('Create Hypothesis'),
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
      final createHypothesis = ref.read(createHypothesisProvider.notifier);
      final hypothesis = await createHypothesis.create(
        CreateHypothesisRequest(
          outcomeId: _selectedOutcomeId!,
          statement: _statementController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          confidence: _confidence,
          ownerId: ownerId,
          effort: _effort,
          impact: _impact,
        ),
      );

      if (mounted && hypothesis != null) {
        Navigator.pop(context, hypothesis);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hypothesis created successfully')),
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
Future<Hypothesis?> showCreateHypothesisDialog(BuildContext context,
    {String? outcomeId}) {
  return showDialog<Hypothesis>(
    context: context,
    builder: (context) => CreateHypothesisDialog(outcomeId: outcomeId),
  );
}
