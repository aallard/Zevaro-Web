import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/hypotheses_providers.dart';
import 'hypothesis_card.dart';

class HypothesisList extends ConsumerWidget {
  const HypothesisList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hypothesesAsync = ref.watch(filteredHypothesesProvider);

    return hypothesesAsync.when(
      data: (hypotheses) {
        if (hypotheses.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.science_outlined,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No hypotheses found',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: hypotheses.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            return HypothesisCard(hypothesis: hypotheses[index]);
          },
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading hypotheses...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(filteredHypothesesProvider),
      ),
    );
  }
}
