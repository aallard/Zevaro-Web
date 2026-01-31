import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../decisions/widgets/create_decision_dialog.dart';
import '../../outcomes/widgets/create_outcome_dialog.dart';
import '../../hypotheses/widgets/create_hypothesis_dialog.dart';
import '../../teams/widgets/invite_member_dialog.dart';

class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Actions', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _QuickActionButton(
                  icon: Icons.help_outline,
                  label: 'New Decision',
                  color: AppColors.error,
                  onTap: () => showCreateDecisionDialog(context),
                ),
                _QuickActionButton(
                  icon: Icons.flag_outlined,
                  label: 'New Outcome',
                  color: AppColors.success,
                  onTap: () => showCreateOutcomeDialog(context),
                ),
                _QuickActionButton(
                  icon: Icons.science_outlined,
                  label: 'New Hypothesis',
                  color: AppColors.warning,
                  onTap: () => showCreateHypothesisDialog(context),
                ),
                _QuickActionButton(
                  icon: Icons.person_add_outlined,
                  label: 'Invite User',
                  color: AppColors.primary,
                  onTap: () => _showTeamSelectionDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTeamSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _TeamSelectionForInviteDialog(),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamSelectionForInviteDialog extends ConsumerWidget {
  const _TeamSelectionForInviteDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(myTeamsProvider);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.group, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Select Team', style: AppTypography.h3),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Which team do you want to invite a member to?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              teamsAsync.when(
                data: (teams) {
                  if (teams.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Center(
                        child: Text(
                          'No teams available. Create a team first.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: teams.map((team) {
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Center(
                            child: Text(
                              team.name.isNotEmpty
                                  ? team.name[0].toUpperCase()
                                  : 'T',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        title: Text(team.name),
                        subtitle: Text('${team.memberCount} members'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(context);
                          showInviteMemberDialog(
                            context,
                            teamId: team.id,
                            teamName: team.name,
                          );
                        },
                      );
                    }).toList(),
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
      ),
    );
  }
}
