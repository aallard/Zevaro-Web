import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/decisions_providers.dart';
import 'decision_column.dart';

class DecisionBoard extends ConsumerWidget {
  const DecisionBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionsAsync = ref.watch(decisionsByStatusProvider);

    return decisionsAsync.when(
      data: (decisionsByStatus) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecisionColumn(
                  status: DecisionStatus.NEEDS_INPUT,
                  decisions: decisionsByStatus[DecisionStatus.NEEDS_INPUT] ?? [],
                ),
                DecisionColumn(
                  status: DecisionStatus.UNDER_DISCUSSION,
                  decisions:
                      decisionsByStatus[DecisionStatus.UNDER_DISCUSSION] ?? [],
                ),
                DecisionColumn(
                  status: DecisionStatus.DECIDED,
                  decisions: decisionsByStatus[DecisionStatus.DECIDED] ?? [],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading decisions...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(decisionsByStatusProvider),
      ),
    );
  }
}
