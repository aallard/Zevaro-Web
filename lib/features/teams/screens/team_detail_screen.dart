import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/teams_providers.dart';
import '../widgets/invite_member_dialog.dart';
import '../widgets/team_member_card.dart';

class TeamDetailScreen extends ConsumerWidget {
  final String id;

  const TeamDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamDetailProvider(id));

    return teamAsync.when(
      data: (team) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            TextButton.icon(
              onPressed: () => context.go(Routes.teams),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Teams'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Center(
                            child: Text(
                              team.name.isNotEmpty
                                  ? team.name[0].toUpperCase()
                                  : 'T',
                              style: AppTypography.h2
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(team.name, style: AppTypography.h2),
                              if (team.description != null)
                                Text(
                                  team.description!,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.people_outline,
                          value: '${team.memberCount}',
                          label: 'Members',
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _StatChip(
                          icon: Icons.flag_outlined,
                          value: '${team.outcomeCount}',
                          label: 'Outcomes',
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _StatChip(
                          icon: Icons.science_outlined,
                          value: '${team.activeHypothesisCount}',
                          label: 'Active Hypotheses',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Members
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Members', style: AppTypography.h4),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => showInviteMemberDialog(
                            context,
                            teamId: team.id,
                            teamName: team.name,
                          ),
                          icon: const Icon(Icons.person_add, size: 16),
                          label: const Text('Invite'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (team.members?.isEmpty ?? true)
                      Center(
                        child: Text(
                          'No members yet',
                          style: TextStyle(color: AppColors.textTertiary),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: team.members!.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final member = team.members![index];
                          return TeamMemberCard(
                            member: member,
                            onChangeRole: () => _showChangeRoleDialog(
                                context, ref, team.id, member),
                            onRemove: () => _confirmRemoveMember(
                                context, ref, team.id, member),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => const LoadingIndicator(message: 'Loading team...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(teamDetailProvider(id)),
      ),
    );
  }

  void _showChangeRoleDialog(
      BuildContext context, WidgetRef ref, String teamId, TeamMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TeamMemberRole.values
              .map((role) => ListTile(
                    title: Text(role.displayName),
                    selected: member.teamRole == role,
                    onTap: () async {
                      await ref
                          .read(updateMemberRoleProvider.notifier)
                          .changeRole(teamId, member.id, role);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _confirmRemoveMember(
      BuildContext context, WidgetRef ref, String teamId, TeamMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Remove ${member.userFullName} from this team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(removeTeamMemberProvider.notifier)
                  .remove(teamId, member.id);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(value, style: AppTypography.labelLarge),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
