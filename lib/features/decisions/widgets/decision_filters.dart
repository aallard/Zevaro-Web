import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/decisions_providers.dart';

class DecisionFiltersBar extends ConsumerWidget {
  const DecisionFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(decisionFiltersProvider);
    final teamsAsync = ref.watch(myTeamsProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // Urgency filter
          _FilterChip(
            label: filters.urgency?.displayName ?? 'Urgency',
            isSelected: filters.urgency != null,
            onTap: () => _showUrgencyPicker(context, ref),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Type filter
          _FilterChip(
            label: filters.type?.displayName ?? 'Type',
            isSelected: filters.type != null,
            onTap: () => _showTypePicker(context, ref),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Team filter
          teamsAsync.when(
            data: (teams) => _FilterChip(
              label: filters.teamId != null
                  ? teams
                          .where((t) => t.id == filters.teamId)
                          .firstOrNull
                          ?.name ??
                      'Team'
                  : 'Team',
              isSelected: filters.teamId != null,
              onTap: () => _showTeamPicker(context, ref, teams),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Clear filters
          if (filters.hasFilters) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton.icon(
              onPressed: () =>
                  ref.read(decisionFiltersProvider.notifier).clearAll(),
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

  void _showUrgencyPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All Urgencies'),
            onTap: () {
              ref.read(decisionFiltersProvider.notifier).setUrgency(null);
              Navigator.pop(context);
            },
          ),
          ...DecisionUrgency.values.map((u) => ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Color(int.parse(u.color.replaceFirst('#', '0xFF'))),
                  size: 12,
                ),
                title: Text(u.displayName),
                subtitle: Text('${u.slaHours}h SLA'),
                onTap: () {
                  ref.read(decisionFiltersProvider.notifier).setUrgency(u);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }

  void _showTypePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All Types'),
            onTap: () {
              ref.read(decisionFiltersProvider.notifier).setType(null);
              Navigator.pop(context);
            },
          ),
          ...DecisionType.values.map((t) => ListTile(
                title: Text(t.displayName),
                onTap: () {
                  ref.read(decisionFiltersProvider.notifier).setType(t);
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
              ref.read(decisionFiltersProvider.notifier).setTeam(null);
              Navigator.pop(context);
            },
          ),
          ...teams.map((t) => ListTile(
                title: Text(t.name),
                onTap: () {
                  ref.read(decisionFiltersProvider.notifier).setTeam(t.id);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }
}
