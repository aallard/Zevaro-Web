import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart' hide DecisionList;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/decisions_providers.dart';
import '../widgets/create_decision_dialog.dart';
import '../widgets/decision_board.dart';
import '../widgets/decision_list.dart';

class DecisionsScreen extends ConsumerWidget {
  const DecisionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(decisionViewModeProvider);
    final filters = ref.watch(decisionFiltersProvider);
    final statsAsync = ref.watch(queueSummaryStatsProvider);

    return Column(
      children: [
        // Summary stats bar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
          ),
          child: statsAsync.when(
            data: (stats) => Row(
              children: [
                _StatChip(
                  label: 'Total',
                  value: '${stats.total}',
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatChip(
                  label: 'Breached',
                  value: '${stats.breached}',
                  color: AppColors.error,
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatChip(
                  label: 'At Risk',
                  value: '${stats.atRisk}',
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatChip(
                  label: 'On Track',
                  value: '${stats.onTrack}',
                  color: AppColors.success,
                ),
                const Spacer(),
                if (filters.hasFilters)
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(decisionFiltersProvider.notifier).clearAll(),
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Clear Filters'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),

        // Toolbar with filters, search, and controls
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row 1: Cascade filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Portfolio dropdown
                    _CascadeDropdown(
                      label: 'Portfolio',
                      value: filters.portfolioId,
                      provider: portfoliosProvider,
                      itemBuilder: (portfolios) => portfolios
                          .map((p) => DropdownMenuItem(
                                value: p.id,
                                child: Text(p.name,
                                    style: AppTypography.bodySmall),
                              ))
                          .toList(),
                      onChanged: (v) => ref
                          .read(decisionFiltersProvider.notifier)
                          .setPortfolio(v),
                    ),
                    const SizedBox(width: AppSpacing.sm),

                    // Program dropdown
                    _CascadeDropdown(
                      label: 'Program',
                      value: filters.programId,
                      provider: programsProvider(),
                      itemBuilder: (programs) => programs
                          .map((p) => DropdownMenuItem(
                                value: p.id,
                                child: Text(p.name,
                                    style: AppTypography.bodySmall),
                              ))
                          .toList(),
                      onChanged: (v) => ref
                          .read(decisionFiltersProvider.notifier)
                          .setProgram(v),
                    ),
                    const SizedBox(width: AppSpacing.sm),

                    // Parent type chips
                    _FilterChipGroup(
                      label: 'Parent',
                      selected: filters.parentType,
                      options: const [
                        'HYPOTHESIS',
                        'SPECIFICATION',
                        'REQUIREMENT',
                        'TICKET',
                        'WORKSTREAM',
                        'PROGRAM',
                      ],
                      onSelected: (v) => ref
                          .read(decisionFiltersProvider.notifier)
                          .setParentType(v),
                    ),
                    const SizedBox(width: AppSpacing.sm),

                    // Execution mode chips
                    _FilterChipGroup(
                      label: 'Mode',
                      selected: filters.executionMode,
                      options: const ['AI_FIRST', 'TRADITIONAL', 'HYBRID'],
                      colors: const {
                        'AI_FIRST': Color(0xFF16A34A),
                        'TRADITIONAL': Color(0xFF6B7280),
                        'HYBRID': Color(0xFFCA8A04),
                      },
                      onSelected: (v) => ref
                          .read(decisionFiltersProvider.notifier)
                          .setExecutionMode(v),
                    ),
                    const SizedBox(width: AppSpacing.sm),

                    // SLA status chips
                    _FilterChipGroup(
                      label: 'SLA',
                      selected: filters.slaStatus,
                      options: const ['BREACHED', 'AT_RISK', 'ON_TRACK'],
                      colors: const {
                        'BREACHED': Color(0xFFDC2626),
                        'AT_RISK': Color(0xFFCA8A04),
                        'ON_TRACK': Color(0xFF16A34A),
                      },
                      onSelected: (v) => ref
                          .read(decisionFiltersProvider.notifier)
                          .setSlaStatus(v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Row 2: Search + view toggle + new decision
              Row(
                children: [
                  // Quick filter pills
                  _FilterPill(
                    label: 'All',
                    isActive: !filters.hasFilters,
                    onTap: () =>
                        ref.read(decisionFiltersProvider.notifier).clearAll(),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _FilterPill(
                    label: 'Blocking',
                    isActive: filters.urgency == DecisionUrgency.BLOCKING,
                    onTap: () => ref
                        .read(decisionFiltersProvider.notifier)
                        .setUrgency(
                          filters.urgency == DecisionUrgency.BLOCKING
                              ? null
                              : DecisionUrgency.BLOCKING,
                        ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  // Search bar
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search decisions...',
                          prefixIcon: const Icon(Icons.search, size: 18),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                            borderSide:
                                const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                            borderSide:
                                const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          ref
                              .read(decisionFiltersProvider.notifier)
                              .setSearch(value.isEmpty ? null : value);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  // View toggle
                  SegmentedButton<ViewMode>(
                    segments: const [
                      ButtonSegment(
                        value: ViewMode.board,
                        icon: Icon(Icons.view_kanban, size: 18),
                      ),
                      ButtonSegment(
                        value: ViewMode.list,
                        icon: Icon(Icons.view_list, size: 18),
                      ),
                    ],
                    selected: {viewMode},
                    onSelectionChanged: (selected) {
                      if (selected.first == ViewMode.board) {
                        ref.read(decisionViewModeProvider.notifier).setBoard();
                      } else {
                        ref.read(decisionViewModeProvider.notifier).setList();
                      }
                    },
                  ),

                  const SizedBox(width: AppSpacing.md),

                  // Add decision button
                  FilledButton.icon(
                    onPressed: () => showCreateDecisionDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Decision'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: viewMode == ViewMode.board
              ? const DecisionBoard()
              : const DecisionList(),
        ),
      ],
    );
  }
}

/// Summary stat chip
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$value $label',
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Cascade dropdown backed by an async provider
class _CascadeDropdown<T> extends ConsumerWidget {
  final String label;
  final String? value;
  final ProviderListenable<AsyncValue<List<T>>> provider;
  final List<DropdownMenuItem<String>> Function(List<T>) itemBuilder;
  final ValueChanged<String?> onChanged;

  const _CascadeDropdown({
    required this.label,
    required this.value,
    required this.provider,
    required this.itemBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(provider);

    return dataAsync.when(
      data: (items) {
        final menuItems = itemBuilder(items);
        return SizedBox(
          width: 160,
          height: 32,
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: AppTypography.labelSmall
                  .copyWith(color: AppColors.textTertiary),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text('All', style: AppTypography.bodySmall),
              ),
              ...menuItems,
            ],
            onChanged: onChanged,
            style: AppTypography.bodySmall,
          ),
        );
      },
      loading: () => SizedBox(
        width: 160,
        height: 32,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Filter chip group with optional colors
class _FilterChipGroup extends StatelessWidget {
  final String label;
  final String? selected;
  final List<String> options;
  final Map<String, Color>? colors;
  final ValueChanged<String?> onSelected;

  const _FilterChipGroup({
    required this.label,
    required this.selected,
    required this.options,
    this.colors,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label:',
          style: AppTypography.labelSmall
              .copyWith(color: AppColors.textTertiary, fontSize: 10),
        ),
        const SizedBox(width: 4),
        ...options.map((opt) {
          final isSelected = selected == opt;
          final color = colors?[opt] ?? AppColors.primary;
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: InkWell(
              onTap: () => onSelected(isSelected ? null : opt),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? color.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: isSelected ? color : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  opt.replaceAll('_', ' '),
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 9,
                    color: isSelected ? color : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

/// Reusable filter pill widget
class _FilterPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isActive ? AppColors.textOnPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
