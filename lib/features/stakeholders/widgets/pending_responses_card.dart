import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/stakeholders_providers.dart';

class PendingResponsesCard extends ConsumerWidget {
  final String stakeholderId;

  const PendingResponsesCard({super.key, required this.stakeholderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync =
        ref.watch(stakeholderPendingResponsesProvider(stakeholderId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pending_actions, color: AppColors.warning),
                const SizedBox(width: AppSpacing.sm),
                Text('Pending Responses', style: AppTypography.h4),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            pendingAsync.when(
              data: (responses) {
                if (responses.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'All caught up! No pending responses.',
                          style: TextStyle(color: AppColors.success),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: responses.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final response = responses[index];
                    final isOverdue = !response.withinSla;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (isOverdue ? AppColors.error : AppColors.warning)
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isOverdue ? Icons.warning : Icons.schedule,
                          color: isOverdue ? AppColors.error : AppColors.warning,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        response.decisionTitle ?? 'Decision',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(
                        children: [
                          if (isOverdue)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Text(
                                'OVERDUE',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (isOverdue) const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Waiting ${response.responseTimeDisplay}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      trailing: TextButton(
                        onPressed: () =>
                            context.go(Routes.decisionById(response.decisionId)),
                        child: const Text('View'),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text('Error: $e'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
