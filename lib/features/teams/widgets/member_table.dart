import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/teams_providers.dart';

class MemberTable extends ConsumerWidget {
  const MemberTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsListProvider);

    return teamsAsync.when(
      data: (teams) {
        if (teams.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.groups_outlined, size: 64,
                    color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.md),
                Text('No team members yet',
                    style: AppTypography.h3
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        // Flatten all team members for the table view
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.cardPadding,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusLg),
                      topRight: Radius.circular(AppSpacing.radiusLg),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text('Team',
                            style: AppTypography.labelMedium),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text('Members',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text('Outcomes',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text('Hypotheses',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
                // Build rows from team data
                ...teams.map((team) => _TeamRow(team: team)),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading teams...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(teamsListProvider),
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final Team team;

  const _TeamRow({required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          // Team info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Center(
                    child: Text(
                      team.name.isNotEmpty ? team.name[0].toUpperCase() : 'T',
                      style: AppTypography.h4.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(team.name,
                          style: AppTypography.labelLarge),
                      if (team.description != null && team.description!.isNotEmpty)
                        Text(team.description!,
                            style: AppTypography.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Member count
          SizedBox(
            width: 100,
            child: Text(
              '${team.memberCount}',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          // Outcome count
          SizedBox(
            width: 100,
            child: Text(
              '${team.outcomeCount}',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          // Hypothesis count
          SizedBox(
            width: 120,
            child: Text(
              '${team.activeHypothesisCount}',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
