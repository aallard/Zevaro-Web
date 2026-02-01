import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/decisions_providers.dart';

class CreateDecisionDialog extends ConsumerStatefulWidget {
  final String? hypothesisId;

  const CreateDecisionDialog({super.key, this.hypothesisId});

  @override
  ConsumerState<CreateDecisionDialog> createState() =>
      _CreateDecisionDialogState();
}

class _CreateDecisionDialogState extends ConsumerState<CreateDecisionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DecisionType _selectedType = DecisionType.PRODUCT;
  DecisionUrgency _selectedUrgency = DecisionUrgency.NORMAL;
  String? _selectedHypothesisId;
  String? _selectedTeamId;
  List<String> _selectedStakeholderIds = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedHypothesisId = widget.hypothesisId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hypothesesAsync = ref.watch(myHypothesesProvider);
    final teamsAsync = ref.watch(myTeamsProvider);
    final teamMembersAsync = _selectedTeamId != null
        ? ref.watch(teamWithMembersProvider(_selectedTeamId!))
        : null;

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
                    const Icon(Icons.help_outline, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text('New Decision', style: AppTypography.h3),
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
                            labelText: 'Decision Title *',
                            hintText: 'What needs to be decided?',
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
                            labelText: 'Context & Details *',
                            hintText: 'Provide background information...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (v) => v?.isEmpty ?? true
                              ? 'Description is required'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Type and Urgency row
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<DecisionType>(
                                value: _selectedType,
                                decoration: const InputDecoration(
                                  labelText: 'Type *',
                                  border: OutlineInputBorder(),
                                ),
                                items: DecisionType.values.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type.displayName),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedType = v!),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: DropdownButtonFormField<DecisionUrgency>(
                                value: _selectedUrgency,
                                decoration: const InputDecoration(
                                  labelText: 'Urgency *',
                                  border: OutlineInputBorder(),
                                ),
                                items: DecisionUrgency.values.map((urgency) {
                                  return DropdownMenuItem(
                                    value: urgency,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: _urgencyColor(urgency),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(urgency.displayName),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedUrgency = v!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Hypothesis selection (required)
                        if (widget.hypothesisId == null)
                          hypothesesAsync.when(
                            data: (hypotheses) =>
                                DropdownButtonFormField<String>(
                              value: _selectedHypothesisId,
                              decoration: const InputDecoration(
                                labelText: 'Blocking Hypothesis *',
                                border: OutlineInputBorder(),
                              ),
                              items: hypotheses.map((h) {
                                return DropdownMenuItem(
                                  value: h.id,
                                  child: Text(
                                    h.statement,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedHypothesisId = v),
                              validator: (v) =>
                                  v == null ? 'Hypothesis is required' : null,
                            ),
                            loading: () => const LinearProgressIndicator(),
                            error: (e, _) => Text('Error loading hypotheses: $e'),
                          ),
                        if (widget.hypothesisId == null)
                          const SizedBox(height: AppSpacing.md),

                        // Team selection (for stakeholder filtering)
                        teamsAsync.when(
                          data: (teams) => DropdownButtonFormField<String>(
                            value: _selectedTeamId,
                            decoration: const InputDecoration(
                              labelText: 'Select Team for Stakeholders *',
                              border: OutlineInputBorder(),
                            ),
                            items: teams.map((team) {
                              return DropdownMenuItem(
                                value: team.id,
                                child: Text(team.name),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() {
                              _selectedTeamId = v;
                              _selectedStakeholderIds = [];
                            }),
                            validator: (v) =>
                                v == null ? 'Team is required' : null,
                          ),
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('Error loading teams: $e'),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Stakeholder selection
                        if (_selectedTeamId != null && teamMembersAsync != null)
                          teamMembersAsync.when(
                            data: (team) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Stakeholders *',
                                    style: AppTypography.labelMedium),
                                const SizedBox(height: AppSpacing.xs),
                                if (team.members?.isEmpty ?? true)
                                  Text(
                                    'No members in this team',
                                    style: AppTypography.bodySmall
                                        .copyWith(color: AppColors.textTertiary),
                                  )
                                else
                                  Wrap(
                                    spacing: AppSpacing.xs,
                                    runSpacing: AppSpacing.xs,
                                    children: team.members!.map((member) {
                                      final isSelected =
                                          _selectedStakeholderIds
                                              .contains(member.user.id);
                                      return FilterChip(
                                        label: Text(member.userFullName),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              _selectedStakeholderIds
                                                  .add(member.user.id);
                                            } else {
                                              _selectedStakeholderIds
                                                  .remove(member.user.id);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                if (_selectedStakeholderIds.isEmpty &&
                                    (team.members?.isNotEmpty ?? false))
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: AppSpacing.xs),
                                    child: Text(
                                      'Select at least one stakeholder',
                                      style: AppTypography.bodySmall
                                          .copyWith(color: AppColors.error),
                                    ),
                                  ),
                              ],
                            ),
                            loading: () => const LinearProgressIndicator(),
                            error: (e, _) => Text('Error: $e'),
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
                          : const Text('Create Decision'),
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

  Color _urgencyColor(DecisionUrgency urgency) {
    switch (urgency) {
      case DecisionUrgency.BLOCKING:
        return AppColors.urgencyBlocking;
      case DecisionUrgency.HIGH:
        return AppColors.urgencyHigh;
      case DecisionUrgency.NORMAL:
        return AppColors.urgencyNormal;
      case DecisionUrgency.LOW:
        return AppColors.urgencyLow;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStakeholderIds.isEmpty) return;

    final hypothesisId = _selectedHypothesisId ?? widget.hypothesisId;
    if (hypothesisId == null) return;

    setState(() => _isLoading = true);

    try {
      final createDecision = ref.read(createDecisionProvider.notifier);
      final decision = await createDecision.create(
        CreateDecisionRequest(
          hypothesisId: hypothesisId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          type: _selectedType,
          urgency: _selectedUrgency,
          stakeholderIds: _selectedStakeholderIds,
        ),
      );

      if (mounted && decision != null) {
        Navigator.pop(context, decision);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Decision created successfully')),
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
Future<Decision?> showCreateDecisionDialog(BuildContext context,
    {String? hypothesisId}) {
  return showDialog<Decision>(
    context: context,
    builder: (context) => CreateDecisionDialog(hypothesisId: hypothesisId),
  );
}
