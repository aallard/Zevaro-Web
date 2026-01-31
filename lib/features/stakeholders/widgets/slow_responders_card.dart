import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';
import '../../../shared/widgets/common/loading_indicator.dart';

class SlowRespondersCard extends ConsumerWidget {
  const SlowRespondersCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slowRespondersAsync = ref.watch(slowRespondersProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer_off, color: AppColors.error),
                const SizedBox(width: AppSpacing.sm),
                Text('Slow Responders', style: AppTypography.h4),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Stakeholders consistently missing SLAs',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            slowRespondersAsync.when(
              data: (stakeholders) {
                if (stakeholders.isEmpty) {
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
                          'Everyone is responding on time!',
                          style: TextStyle(color: AppColors.success),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stakeholders.length.clamp(0, 5),
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final s = stakeholders[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ZAvatar(name: s.fullName, size: 36),
                      title: Text(s.fullName),
                      subtitle: Text(
                        '${((s.stats?.slaComplianceRate ?? 0) * 100).toStringAsFixed(0)}% SLA compliance',
                      ),
                      trailing: TextButton(
                        onPressed: () =>
                            context.go(Routes.stakeholderById(s.id)),
                        child: const Text('View'),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
