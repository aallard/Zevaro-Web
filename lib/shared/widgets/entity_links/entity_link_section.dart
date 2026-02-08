import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/entity_link_action_providers.dart';
import '../../utils/entity_navigation.dart';
import '../common/loading_indicator.dart';
import '../common/error_view.dart';
import 'create_link_dialog.dart';

class EntityLinkSection extends ConsumerWidget {
  final EntityType entityType;
  final String entityId;

  const EntityLinkSection({
    super.key,
    required this.entityType,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linksAsync =
        ref.watch(entityLinksProvider(entityType, entityId));

    return linksAsync.when(
      data: (links) {
        // Split into outgoing (from this entity) and incoming (to this entity)
        final outgoing =
            links.where((l) => l.sourceId == entityId).toList();
        final incoming =
            links.where((l) => l.targetId == entityId).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Text(
                    '${links.length} ${links.length == 1 ? 'link' : 'links'}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () => _showCreateDialog(context),
                    icon: const Icon(Icons.add_link, size: 16),
                    label: const Text('Add Link'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs),
                      textStyle: AppTypography.labelSmall,
                    ),
                  ),
                ],
              ),
            ),

            if (links.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link_outlined,
                          size: 36, color: AppColors.textTertiary),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'No linked entities',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              if (outgoing.isNotEmpty) ...[
                _SectionHeader(label: 'Outgoing'),
                ...outgoing.map((link) => _LinkRow(
                      link: link,
                      direction: _LinkDirection.outgoing,
                      entityType: entityType,
                      entityId: entityId,
                    )),
              ],
              if (incoming.isNotEmpty) ...[
                _SectionHeader(label: 'Incoming'),
                ...incoming.map((link) => _LinkRow(
                      link: link,
                      direction: _LinkDirection.incoming,
                      entityType: entityType,
                      entityId: entityId,
                    )),
              ],
            ],
          ],
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading links...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(entityLinksProvider(entityType, entityId)),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreateLinkDialog(
        sourceType: entityType,
        sourceId: entityId,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

enum _LinkDirection { outgoing, incoming }

class _LinkRow extends ConsumerWidget {
  final EntityLink link;
  final _LinkDirection direction;
  final EntityType entityType;
  final String entityId;

  const _LinkRow({
    required this.link,
    required this.direction,
    required this.entityType,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetType = direction == _LinkDirection.outgoing
        ? link.targetType
        : link.sourceType;
    final targetId = direction == _LinkDirection.outgoing
        ? link.targetId
        : link.sourceId;
    final targetTitle = direction == _LinkDirection.outgoing
        ? link.targetTitle
        : link.sourceTitle;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Link type badge
          _LinkTypeBadge(linkType: link.linkType),
          const SizedBox(width: AppSpacing.sm),

          // Direction arrow
          Icon(
            direction == _LinkDirection.outgoing
                ? Icons.arrow_forward
                : Icons.arrow_back,
            size: 14,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.sm),

          // Target entity
          Expanded(
            child: InkWell(
              onTap: () =>
                  context.go(getEntityRoute(targetType, targetId)),
              child: Row(
                children: [
                  Icon(
                    _entityIcon(targetType),
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: Text(
                      targetTitle ?? entityTypeLabel(targetType),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Delete
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => ref
                .read(entityLinkActionsProvider.notifier)
                .deleteLink(link.id, entityType, entityId),
            tooltip: 'Remove link',
            iconSize: 16,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  IconData _entityIcon(EntityType type) {
    switch (type) {
      case EntityType.PORTFOLIO:
        return Icons.business_center_outlined;
      case EntityType.PROGRAM:
        return Icons.folder_outlined;
      case EntityType.WORKSTREAM:
        return Icons.account_tree_outlined;
      case EntityType.OUTCOME:
        return Icons.flag_outlined;
      case EntityType.HYPOTHESIS:
        return Icons.lightbulb_outlined;
      case EntityType.EXPERIMENT:
        return Icons.science_outlined;
      case EntityType.DECISION:
        return Icons.bolt_outlined;
      case EntityType.SPECIFICATION:
        return Icons.description_outlined;
      case EntityType.REQUIREMENT:
        return Icons.checklist_outlined;
      case EntityType.TICKET:
        return Icons.bug_report_outlined;
      case EntityType.DOCUMENT:
        return Icons.article_outlined;
      case EntityType.SPACE:
        return Icons.library_books_outlined;
    }
  }
}

class _LinkTypeBadge extends StatelessWidget {
  final LinkType linkType;

  const _LinkTypeBadge({required this.linkType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        _label,
        style: AppTypography.labelSmall.copyWith(
          color: _textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String get _label => linkTypeLabel(linkType);

  Color get _backgroundColor {
    switch (linkType) {
      case LinkType.BLOCKS:
        return Colors.red.shade50;
      case LinkType.DEPENDS_ON:
        return Colors.orange.shade50;
      case LinkType.IMPLEMENTS:
        return Colors.green.shade50;
      case LinkType.REFERENCES:
        return Colors.blue.shade50;
      case LinkType.RELATES_TO:
        return Colors.grey.shade100;
    }
  }

  Color get _textColor {
    switch (linkType) {
      case LinkType.BLOCKS:
        return Colors.red.shade700;
      case LinkType.DEPENDS_ON:
        return Colors.orange.shade700;
      case LinkType.IMPLEMENTS:
        return Colors.green.shade700;
      case LinkType.REFERENCES:
        return Colors.blue.shade700;
      case LinkType.RELATES_TO:
        return Colors.grey.shade700;
    }
  }
}
