import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../../../shared/widgets/common/avatar.dart';
import '../providers/activity_action_providers.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeFilter = ref.watch(activityEntityFilterProvider);
    final feedAsync = ref.watch(filteredActivityFeedProvider);

    return Column(
      children: [
        // Header + filters
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activity Feed', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.sm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: typeFilter == null,
                      onTap: () => ref
                          .read(activityEntityFilterProvider.notifier)
                          .clear(),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    ..._entityTypes.map((t) => Padding(
                          padding:
                              const EdgeInsets.only(right: AppSpacing.xs),
                          child: _FilterChip(
                            label: t,
                            isSelected: typeFilter == t,
                            onTap: () => ref
                                .read(activityEntityFilterProvider.notifier)
                                .set(t),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Timeline
        Expanded(
          child: feedAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history,
                          size: 48, color: AppColors.textTertiary),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'No activity yet',
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
                itemCount: events.length,
                itemBuilder: (_, index) => _ActivityEventRow(
                  event: events[index],
                  isLast: index == events.length - 1,
                ),
              );
            },
            loading: () =>
                const LoadingIndicator(message: 'Loading activity...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () =>
                  ref.invalidate(filteredActivityFeedProvider),
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

class _ActivityEventRow extends StatelessWidget {
  final ActivityEvent event;
  final bool isLast;

  const _ActivityEventRow({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline gutter
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _actionColor(event.action),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.border,
                    ),
                  ),
              ],
            ),
          ),

          // Event content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZAvatar(
                      name: event.actorName ?? 'System',
                      size: 28,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: AppTypography.bodySmall,
                              children: [
                                TextSpan(
                                  text: event.actorName ?? 'System',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: ' ${_actionLabel(event.action)}',
                                ),
                                if (event.entityTitle != null)
                                  TextSpan(
                                    text: ' ${event.entityTitle}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              // Entity type badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textTertiary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusSm),
                                ),
                                child: Text(
                                  event.entityType,
                                  style:
                                      AppTypography.labelSmall.copyWith(
                                    fontSize: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                _formatTimestamp(event.timestamp),
                                style:
                                    AppTypography.labelSmall.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          if (event.details != null) ...[
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              event.details!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Navigate to entity
                    if (event.entityId != null)
                      IconButton(
                        icon: const Icon(Icons.open_in_new,
                            size: 16, color: AppColors.textTertiary),
                        onPressed: () {
                          final route = _routeForEvent(event);
                          if (route != null) {
                            GoRouter.of(context).go(route);
                          }
                        },
                        tooltip: 'Go to entity',
                        iconSize: 16,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _actionLabel(String action) {
    switch (action.toUpperCase()) {
      case 'CREATED':
        return 'created';
      case 'UPDATED':
        return 'updated';
      case 'DELETED':
        return 'deleted';
      case 'STATUS_CHANGED':
        return 'changed status of';
      case 'COMMENT_ADDED':
        return 'commented on';
      case 'ASSIGNED':
        return 'assigned';
      default:
        return action.toLowerCase().replaceAll('_', ' ');
    }
  }

  Color _actionColor(String action) {
    switch (action.toUpperCase()) {
      case 'CREATED':
        return const Color(0xFF16A34A);
      case 'UPDATED':
        return AppColors.primary;
      case 'DELETED':
        return AppColors.error;
      case 'STATUS_CHANGED':
        return const Color(0xFFCA8A04);
      default:
        return AppColors.textTertiary;
    }
  }

  String? _routeForEvent(ActivityEvent e) {
    final id = e.entityId;
    if (id == null) return null;
    final type = e.entityType.toUpperCase();
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
      default:
        return null;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.MMMd().format(timestamp);
  }
}
