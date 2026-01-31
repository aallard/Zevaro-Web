import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/outcomes_providers.dart';
import 'outcome_card.dart';

class OutcomeList extends ConsumerWidget {
  const OutcomeList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outcomesAsync = ref.watch(filteredOutcomesProvider);

    return outcomesAsync.when(
      data: (outcomes) {
        if (outcomes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('No outcomes found'),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 1.3,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemCount: outcomes.length,
          itemBuilder: (context, index) {
            return OutcomeCard(outcome: outcomes[index]);
          },
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading outcomes...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(filteredOutcomesProvider),
      ),
    );
  }
}
