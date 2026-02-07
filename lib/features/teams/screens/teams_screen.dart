import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../widgets/member_table.dart';
import '../widgets/stakeholder_scorecard.dart';
import '../widgets/workload_matrix.dart';
import '../providers/teams_providers.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamMembersAsync = ref.watch(teamMembersWithStatsProvider);
    final stakeholdersAsync = ref.watch(teamStakeholdersProvider);

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Summary bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePaddingHorizontal,
              vertical: AppSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: teamMembersAsync.when(
              data: (members) => stakeholdersAsync.when(
                data: (stakeholders) {
                  // Calculate pending decisions across team
                  int totalPendingDecisions = 0;
                  for (final stakeholder in stakeholders) {
                    totalPendingDecisions += stakeholder.pendingDecisionCount as int;
                  }

                  return Text(
                    '${members.length} Members · ${stakeholders.length} Stakeholders · $totalPendingDecisions Pending Decisions across team',
                    style: AppTypography.bodySmall,
                  );
                },
                loading: () => Text(
                  '${members.length} Members · Loading...',
                  style: AppTypography.bodySmall,
                ),
                error: (_, __) => Text(
                  '${members.length} Members · Error loading stakeholders',
                  style: AppTypography.bodySmall,
                ),
              ),
              loading: () => Text(
                'Loading team information...',
                style: AppTypography.bodySmall,
              ),
              error: (_, __) => Text(
                'Error loading team',
                style: AppTypography.bodySmall,
              ),
            ),
          ),

          // Toolbar with tabs
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePaddingHorizontal,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'Members'),
                    Tab(text: 'Stakeholders'),
                    Tab(text: 'Workload'),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Invite Member'),
                  ),
                ),
              ],
            ),
          ),

          // Content
          const Expanded(
            child: TabBarView(
              children: [
                MemberTable(),
                StakeholderScorecard(),
                WorkloadMatrix(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
