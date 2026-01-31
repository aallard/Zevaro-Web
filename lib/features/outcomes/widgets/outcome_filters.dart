import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/outcomes_providers.dart';

class OutcomeFiltersBar extends ConsumerWidget {
  const OutcomeFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(outcomeFiltersProvider);
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

          // Priority filter
          FilterChip(
            label: Text(filters.priority?.displayName ?? 'Priority'),
            selected: filters.priority != null,
            onSelected: (_) => _showPriorityPicker(context, ref),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Team filter
          teamsAsync.when(
            data: (teams) => FilterChip(
              label: Text(filters.teamId != null
                  ? teams
                          .where((t) => t.id == filters.teamId)
                          .firstOrNull
                          ?.name ??
                      'Team'
                  : 'Team'),
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
                  ref.read(outcomeFiltersProvider.notifier).clearAll(),
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear'),
              style:
                  TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
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
              ref.read(outcomeFiltersProvider.notifier).setStatus(null);
              Navigator.pop(context);
            },
          ),
          ...OutcomeStatus.values.map((s) => ListTile(
                leading: Icon(Icons.circle,
                    color: Color(
                        int.parse(s.color.replaceFirst('#', '0xFF'))),
                    size: 12),
                title: Text(s.displayName),
                onTap: () {
                  ref.read(outcomeFiltersProvider.notifier).setStatus(s);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }

  void _showPriorityPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All Priorities'),
            onTap: () {
              ref.read(outcomeFiltersProvider.notifier).setPriority(null);
              Navigator.pop(context);
            },
          ),
          ...OutcomePriority.values.map((p) => ListTile(
                leading: Icon(Icons.circle,
                    color: Color(
                        int.parse(p.color.replaceFirst('#', '0xFF'))),
                    size: 12),
                title: Text(p.displayName),
                onTap: () {
                  ref.read(outcomeFiltersProvider.notifier).setPriority(p);
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
              ref.read(outcomeFiltersProvider.notifier).setTeam(null);
              Navigator.pop(context);
            },
          ),
          ...teams.map((t) => ListTile(
                title: Text(t.name),
                onTap: () {
                  ref.read(outcomeFiltersProvider.notifier).setTeam(t.id);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}
