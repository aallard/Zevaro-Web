import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/hypotheses_providers.dart';

class HypothesisFiltersBar extends ConsumerWidget {
  const HypothesisFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(hypothesisFiltersProvider);
    final teamsAsync = ref.watch(myTeamsProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // Status filter
          FilterChip(
            label: Text(filters.status?.displayName ?? 'Status'),
            selected: filters.status != null,
            onSelected: (_) => _showStatusPicker(context, ref),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Blocked only filter
          FilterChip(
            label: const Text('Blocked Only'),
            selected: filters.onlyBlocked,
            onSelected: (selected) {
              ref
                  .read(hypothesisFiltersProvider.notifier)
                  .setOnlyBlocked(selected);
            },
          ),
          const SizedBox(width: AppSpacing.sm),

          // Team filter
          teamsAsync.when(
            data: (teams) => FilterChip(
              label: Text(
                filters.teamId != null
                    ? teams
                            .where((t) => t.id == filters.teamId)
                            .firstOrNull
                            ?.name ??
                        'Team'
                    : 'Team',
              ),
              selected: filters.teamId != null,
              onSelected: (_) => _showTeamPicker(context, ref, teams),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Clear filters
          if (filters.hasFilters) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton.icon(
              onPressed: () =>
                  ref.read(hypothesisFiltersProvider.notifier).clearAll(),
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showStatusPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All Statuses'),
            onTap: () {
              ref.read(hypothesisFiltersProvider.notifier).setStatus(null);
              Navigator.pop(context);
            },
          ),
          ...HypothesisStatus.values.map((s) => ListTile(
                leading: Icon(
                  Icons.circle,
                  color:
                      Color(int.parse(s.color.replaceFirst('#', '0xFF'))),
                  size: 12,
                ),
                title: Text(s.displayName),
                onTap: () {
                  ref.read(hypothesisFiltersProvider.notifier).setStatus(s);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }

  void _showTeamPicker(BuildContext context, WidgetRef ref, List<Team> teams) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All Teams'),
            onTap: () {
              ref.read(hypothesisFiltersProvider.notifier).setTeam(null);
              Navigator.pop(context);
            },
          ),
          ...teams.map((t) => ListTile(
                title: Text(t.name),
                onTap: () {
                  ref.read(hypothesisFiltersProvider.notifier).setTeam(t.id);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}
