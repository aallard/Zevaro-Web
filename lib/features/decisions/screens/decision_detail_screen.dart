import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/decisions_providers.dart';
import '../widgets/decision_header.dart';
import '../widgets/decision_description.dart';
import '../widgets/decision_votes.dart';
import '../widgets/decision_comments.dart';
import '../widgets/decision_resolution.dart';

class DecisionDetailScreen extends ConsumerWidget {
  final String id;

  const DecisionDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionAsync = ref.watch(decisionDetailProvider(id));
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppConstants.tabletBreakpoint;

    return decisionAsync.when(
      data: (decision) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            TextButton.icon(
              onPressed: () => context.go(Routes.decisions),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Queue'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Header
            DecisionHeader(
              decision: decision,
              onEscalate: decision.status != DecisionStatus.DECIDED
                  ? () => _showEscalateDialog(context, ref, decision)
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Content
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        DecisionDescription(decision: decision),
                        const SizedBox(height: AppSpacing.lg),
                        DecisionComments(decision: decision),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  // Right column
                  Expanded(
                    child: Column(
                      children: [
                        DecisionVotes(decision: decision),
                        if (decision.status != DecisionStatus.DECIDED) ...[
                          const SizedBox(height: AppSpacing.lg),
                          _ResolveButton(decision: decision),
                        ],
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              DecisionDescription(decision: decision),
              const SizedBox(height: AppSpacing.lg),
              DecisionVotes(decision: decision),
              const SizedBox(height: AppSpacing.lg),
              DecisionComments(decision: decision),
              if (decision.status != DecisionStatus.DECIDED) ...[
                const SizedBox(height: AppSpacing.lg),
                _ResolveButton(decision: decision),
              ],
            ],

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      loading: () => const LoadingIndicator(message: 'Loading decision...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(decisionDetailProvider(id)),
      ),
    );
  }

  void _showEscalateDialog(
      BuildContext context, WidgetRef ref, Decision decision) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escalate Decision'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select new urgency level:'),
            const SizedBox(height: AppSpacing.md),
            ...DecisionUrgency.values
                .where((u) => u.sortOrder < decision.urgency.sortOrder)
                .map((u) => ListTile(
                      title: Text(u.displayName),
                      subtitle: Text('${u.slaHours}h SLA'),
                      onTap: () async {
                        Navigator.pop(context);
                        await ref
                            .read(decisionActionsProvider.notifier)
                            .escalate(decision.id, u);
                        ref.invalidate(decisionDetailProvider(decision.id));
                      },
                    )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _ResolveButton extends StatelessWidget {
  final Decision decision;

  const _ResolveButton({required this.decision});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showResolveDialog(context),
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Resolve Decision'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          padding: const EdgeInsets.all(AppSpacing.md),
        ),
      ),
    );
  }

  void _showResolveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DecisionResolutionDialog(decision: decision),
    );
  }
}
