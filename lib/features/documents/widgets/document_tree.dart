import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';

class DocumentTree extends ConsumerWidget {
  final String spaceId;
  final String? selectedDocumentId;
  final ValueChanged<String> onSelectDocument;

  const DocumentTree({
    super.key,
    required this.spaceId,
    required this.selectedDocumentId,
    required this.onSelectDocument,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeAsync = ref.watch(documentTreeProvider(spaceId));

    return treeAsync.when(
      data: (nodes) {
        if (nodes.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'No documents yet',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.xs),
          children: nodes
              .map((node) => _TreeNodeWidget(
                    node: node,
                    depth: 0,
                    selectedDocumentId: selectedDocumentId,
                    onSelectDocument: onSelectDocument,
                  ))
              .toList(),
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(documentTreeProvider(spaceId)),
      ),
    );
  }
}

class _TreeNodeWidget extends StatefulWidget {
  final DocumentTreeNode node;
  final int depth;
  final String? selectedDocumentId;
  final ValueChanged<String> onSelectDocument;

  const _TreeNodeWidget({
    required this.node,
    required this.depth,
    required this.selectedDocumentId,
    required this.onSelectDocument,
  });

  @override
  State<_TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<_TreeNodeWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selectedDocumentId == widget.node.id;
    final hasChildren = widget.node.children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () =>
                widget.onSelectDocument(widget.node.id),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 1),
              padding: EdgeInsets.only(
                left: AppSpacing.xs + (widget.depth * 16.0),
                right: AppSpacing.xs,
                top: AppSpacing.xxs,
                bottom: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  // Expand/collapse toggle
                  if (hasChildren)
                    GestureDetector(
                      onTap: () =>
                          setState(() => _isExpanded = !_isExpanded),
                      child: Icon(
                        _isExpanded
                            ? Icons.expand_more
                            : Icons.chevron_right,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                    )
                  else
                    const SizedBox(width: 16),
                  const SizedBox(width: 4),

                  // Type icon
                  Icon(
                    _typeIcon(widget.node.type),
                    size: 16,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),

                  // Title
                  Expanded(
                    child: Text(
                      widget.node.title,
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Draft indicator
                  if (widget.node.status == DocumentStatus.DRAFT)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Children
        if (_isExpanded && hasChildren)
          ...widget.node.children.map((child) => _TreeNodeWidget(
                node: child,
                depth: widget.depth + 1,
                selectedDocumentId: widget.selectedDocumentId,
                onSelectDocument: widget.onSelectDocument,
              )),
      ],
    );
  }

  IconData _typeIcon(DocumentType type) {
    switch (type) {
      case DocumentType.PAGE:
        return Icons.article_outlined;
      case DocumentType.SPECIFICATION:
        return Icons.description_outlined;
      case DocumentType.TEMPLATE:
        return Icons.copy_outlined;
      case DocumentType.MEETING_NOTES:
        return Icons.groups_outlined;
      case DocumentType.DECISION_RECORD:
        return Icons.gavel_outlined;
      case DocumentType.RFC:
        return Icons.request_page_outlined;
      case DocumentType.RUNBOOK:
        return Icons.menu_book_outlined;
    }
  }
}
