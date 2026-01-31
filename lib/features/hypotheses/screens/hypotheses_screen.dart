import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/create_hypothesis_dialog.dart';
import '../widgets/hypothesis_list.dart';
import '../widgets/hypothesis_filters.dart';

class HypothesesScreen extends ConsumerWidget {
  const HypothesesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              const Expanded(child: HypothesisFiltersBar()),
              const SizedBox(width: AppSpacing.md),
              FilledButton.icon(
                onPressed: () => showCreateHypothesisDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Hypothesis'),
              ),
            ],
          ),
        ),

        // Content
        const Expanded(child: HypothesisList()),
      ],
    );
  }
}
