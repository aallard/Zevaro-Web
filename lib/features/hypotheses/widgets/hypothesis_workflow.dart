import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/hypotheses_providers.dart';

class HypothesisWorkflow extends ConsumerWidget {
  final Hypothesis hypothesis;

  const HypothesisWorkflow({super.key, required this.hypothesis});

  static const _workflowOrder = [
    HypothesisStatus.DRAFT,
    HypothesisStatus.READY,
    HypothesisStatus.BUILDING,
    HypothesisStatus.DEPLOYED,
    HypothesisStatus.MEASURING,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transitionState = ref.watch(transitionHypothesisStatusProvider);
    final isLoading = transitionState.isLoading;

    // Terminal states show final result
    if (hypothesis.status.isTerminal) {
      return _buildTerminalState(context);
    }

    // Blocked state shows special UI
    if (hypothesis.status == HypothesisStatus.BLOCKED) {
      return _buildBlockedState(context, ref, isLoading);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Workflow', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.md),

            // Workflow steps
            Row(
              children: _workflowOrder.asMap().entries.map((entry) {
                final index = entry.key;
                final status = entry.value;
                final isCurrent = hypothesis.status == status;
                final isPast = _workflowOrder.indexOf(hypothesis.status) > index;

                return Expanded(
                  child: Row(
                    children: [
                      _WorkflowStep(
                        status: status,
                        isCurrent: isCurrent,
                        isPast: isPast,
                      ),
                      if (index < _workflowOrder.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: isPast ? AppColors.success : AppColors.border,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Action buttons
            Text('Available Actions', style: AppTypography.labelMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                ...hypothesis.status.allowedTransitions.map((nextStatus) {
                  return ElevatedButton(
                    onPressed:
                        isLoading ? null : () => _transition(ref, nextStatus),
                    child: Text('Move to ${nextStatus.displayName}'),
                  );
                }),
                if (hypothesis.status == HypothesisStatus.MEASURING) ...[
                  ElevatedButton.icon(
                    onPressed:
                        isLoading ? null : () => _showValidateDialog(context, ref),
                    icon: const Icon(Icons.verified),
                    label: const Text('Validate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => _showInvalidateDialog(context, ref),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Invalidate'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminalState(BuildContext context) {
    final isValidated = hypothesis.status == HypothesisStatus.VALIDATED;
    final color = isValidated ? AppColors.success : AppColors.error;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: color, width: 4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isValidated ? Icons.verified : Icons.cancel,
                  color: color,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  isValidated ? 'Hypothesis Validated' : 'Hypothesis Invalidated',
                  style: AppTypography.h4.copyWith(color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockedState(
      BuildContext context, WidgetRef ref, bool isLoading) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: AppColors.error, width: 4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.block, color: AppColors.error),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Blocked - Waiting for Decision',
                  style: AppTypography.h4.copyWith(color: AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'This hypothesis is blocked until the related decision is resolved.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: hypothesis.status.allowedTransitions.map((nextStatus) {
                return OutlinedButton(
                  onPressed:
                      isLoading ? null : () => _transition(ref, nextStatus),
                  child: Text('Move to ${nextStatus.displayName}'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _transition(WidgetRef ref, HypothesisStatus newStatus) {
    ref.read(transitionHypothesisStatusProvider.notifier).transition(
          hypothesis.id,
          newStatus,
        );
  }

  void _showValidateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validate Hypothesis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Confirm that this hypothesis has been validated.'),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Learnings (optional)',
                hintText: 'What did you learn?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(validateHypothesisProvider.notifier).validate(
                    hypothesis.id,
                    notes:
                        controller.text.isNotEmpty ? controller.text : null,
                  );
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Validate'),
          ),
        ],
      ),
    );
  }

  void _showInvalidateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalidate Hypothesis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Confirm that this hypothesis has been invalidated.'),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Learnings (optional)',
                hintText: 'What did you learn?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(invalidateHypothesisProvider.notifier).invalidate(
                    hypothesis.id,
                    notes:
                        controller.text.isNotEmpty ? controller.text : null,
                  );
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Invalidate'),
          ),
        ],
      ),
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  final HypothesisStatus status;
  final bool isCurrent;
  final bool isPast;

  const _WorkflowStep({
    required this.status,
    required this.isCurrent,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    if (isCurrent) {
      color = AppColors.primary;
    } else if (isPast) {
      color = AppColors.success;
    } else {
      color = AppColors.border;
    }

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCurrent || isPast ? color : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: isPast
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : isCurrent
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          status.displayName,
          style: AppTypography.labelSmall.copyWith(
            color: isCurrent ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
