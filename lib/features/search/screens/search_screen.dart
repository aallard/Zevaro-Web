import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/search_action_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).set(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final typeFilter = ref.watch(searchTypeFilterProvider);
    final resultsAsync = ref.watch(filteredSearchResultsProvider);

    return Column(
      children: [
        // Search bar + filters
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.md,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            children: [
              // Search input
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search across all entities...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _controller.clear();
                            ref.read(searchQueryProvider.notifier).clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: AppSpacing.sm),
              // Type filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: typeFilter == null,
                      onTap: () =>
                          ref.read(searchTypeFilterProvider.notifier).clear(),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    ..._entityTypes.map((t) => Padding(
                          padding:
                              const EdgeInsets.only(right: AppSpacing.xs),
                          child: _FilterChip(
                            label: t,
                            isSelected: typeFilter == t,
                            onTap: () => ref
                                .read(searchTypeFilterProvider.notifier)
                                .set(t),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Results
        Expanded(
          child: query.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, size: 48, color: AppColors.textTertiary),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Start typing to search',
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              : resultsAsync.when(
                  data: (results) {
                    if (results.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off,
                                size: 48, color: AppColors.textTertiary),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'No results found for "$query"',
                              style: AppTypography.bodyMedium
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(
                          AppSpacing.pagePaddingHorizontal),
                      itemCount: results.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (_, index) =>
                          _SearchResultCard(result: results[index]),
                    );
                  },
                  loading: () => const LoadingIndicator(
                      message: 'Searching...'),
                  error: (e, _) => ErrorView(
                    message: e.toString(),
                    onRetry: () =>
                        ref.invalidate(filteredSearchResultsProvider),
                  ),
                ),
        ),
      ],
    );
  }

  static const _entityTypes = [
    'PROGRAM',
    'WORKSTREAM',
    'SPECIFICATION',
    'REQUIREMENT',
    'TICKET',
    'DOCUMENT',
    'DECISION',
    'OUTCOME',
    'HYPOTHESIS',
    'EXPERIMENT',
  ];
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final SearchResult result;

  const _SearchResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final route = _routeForResult(result);
        if (route != null) context.go(route);
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Entity type badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: _colorForType(result.entityType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                result.entityType,
                style: AppTypography.labelSmall.copyWith(
                  color: _colorForType(result.entityType),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Title + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.title, style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
                  if (result.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      result.description!,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Status
            if (result.status != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  result.status!,
                  style: AppTypography.labelSmall.copyWith(fontSize: 10),
                ),
              ),
            ],

            // Program
            if (result.programName != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                result.programName!,
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.textTertiary),
              ),
            ],

            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.chevron_right,
                size: 16, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  String? _routeForResult(SearchResult r) {
    final type = r.entityType.toUpperCase();
    final id = r.entityId;
    switch (type) {
      case 'PROGRAM':
        return '/programs/$id';
      case 'WORKSTREAM':
        return '/workstreams/$id';
      case 'SPECIFICATION':
        return '/specifications/$id';
      case 'REQUIREMENT':
        return '/requirements/$id';
      case 'TICKET':
        return '/tickets/$id';
      case 'DOCUMENT':
        return '/documents/$id';
      case 'DECISION':
        return '/decisions/$id';
      case 'OUTCOME':
        return '/outcomes/$id';
      case 'HYPOTHESIS':
        return '/hypotheses/$id';
      case 'EXPERIMENT':
        return '/experiments/$id';
      case 'PORTFOLIO':
        return '/portfolios/$id';
      case 'SPACE':
        return '/spaces/$id';
      default:
        return null;
    }
  }

  Color _colorForType(String type) {
    switch (type.toUpperCase()) {
      case 'PROGRAM':
        return AppColors.primary;
      case 'WORKSTREAM':
        return const Color(0xFF7C3AED);
      case 'SPECIFICATION':
        return const Color(0xFF2563EB);
      case 'REQUIREMENT':
        return const Color(0xFF0891B2);
      case 'TICKET':
        return const Color(0xFFEA580C);
      case 'DOCUMENT':
        return const Color(0xFF059669);
      case 'DECISION':
        return const Color(0xFFDC2626);
      case 'OUTCOME':
        return const Color(0xFF16A34A);
      case 'HYPOTHESIS':
        return const Color(0xFFCA8A04);
      case 'EXPERIMENT':
        return const Color(0xFF9333EA);
      default:
        return AppColors.textSecondary;
    }
  }
}
