import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/outcomes_providers.dart';
import 'add_key_result_dialog.dart';
import 'key_result_card.dart';

class OutcomeKeyResults extends ConsumerWidget {
  final Outcome outcome;

  const OutcomeKeyResults({super.key, required this.outcome});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyResults = outcome.keyResults ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Key Results', style: AppTypography.h4),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '(${keyResults.length})',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (outcome.status.isEditable)
                  TextButton.icon(
                    onPressed: () => showAddKeyResultDialog(
                      context,
                      outcomeId: outcome.id,
                      outcomeTitle: outcome.title,
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (keyResults.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Icon(Icons.flag_outlined,
                          size: 32, color: AppColors.textTertiary),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'No key results defined',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: keyResults.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final kr = keyResults[index];
                  return KeyResultCard(
                    keyResult: kr,
                    onUpdateProgress: outcome.status.isEditable
                        ? () => _showUpdateProgressDialog(context, ref, kr)
                        : null,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showUpdateProgressDialog(
      BuildContext context, WidgetRef ref, KeyResult kr) {
    final controller = TextEditingController(text: kr.currentValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Progress'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kr.description),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Current Value',
                suffixText: kr.unit,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Target: ${kr.targetValue} ${kr.unit}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
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
              final newValue = double.tryParse(controller.text);
              if (newValue != null) {
                await ref
                    .read(updateKeyResultProgressProvider.notifier)
                    .updateProgress(outcome.id, kr.id, newValue);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
