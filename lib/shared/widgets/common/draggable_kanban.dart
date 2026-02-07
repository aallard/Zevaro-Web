import 'package:flutter/material.dart';
import 'package:zevaro_web/core/theme/app_colors.dart';
import 'package:zevaro_web/core/theme/app_spacing.dart';
import 'package:zevaro_web/core/theme/app_typography.dart';

/// Configuration for a kanban column
class KanbanColumn<T> {
  const KanbanColumn({
    required this.id,
    required this.title,
    required this.items,
    this.headerColor,
    this.backgroundColor,
    this.icon,
    this.maxItems,
  });

  final String id;
  final String title;
  final List<T> items;
  final Color? headerColor;
  final Color? backgroundColor;
  final IconData? icon;
  final int? maxItems;
}

/// A reusable kanban board with drag-and-drop support
class DraggableKanban<T> extends StatelessWidget {
  const DraggableKanban({
    super.key,
    required this.columns,
    required this.cardBuilder,
    required this.onCardMoved,
    required this.idExtractor,
    this.columnMinWidth = 280,
    this.cardSpacing = 8,
    this.emptyColumnBuilder,
  });

  final List<KanbanColumn<T>> columns;
  final Widget Function(T item, bool isDragging) cardBuilder;
  final void Function(T item, String fromColumnId, String toColumnId) onCardMoved;
  final String Function(T item) idExtractor;
  final double columnMinWidth;
  final double cardSpacing;
  final Widget Function(String columnId)? emptyColumnBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = (constraints.maxWidth - ((columns.length - 1) * AppSpacing.sm)) / columns.length;
        final effectiveWidth = columnWidth < columnMinWidth ? columnMinWidth : columnWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columns.map((column) {
              return Padding(
                padding: EdgeInsets.only(
                  right: column == columns.last ? 0 : AppSpacing.sm,
                ),
                child: _KanbanColumnWidget<T>(
                  column: column,
                  width: effectiveWidth,
                  cardBuilder: cardBuilder,
                  onCardMoved: onCardMoved,
                  idExtractor: idExtractor,
                  cardSpacing: cardSpacing,
                  emptyColumnBuilder: emptyColumnBuilder,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _KanbanColumnWidget<T> extends StatefulWidget {
  const _KanbanColumnWidget({
    required this.column,
    required this.width,
    required this.cardBuilder,
    required this.onCardMoved,
    required this.idExtractor,
    required this.cardSpacing,
    this.emptyColumnBuilder,
  });

  final KanbanColumn<T> column;
  final double width;
  final Widget Function(T item, bool isDragging) cardBuilder;
  final void Function(T item, String fromColumnId, String toColumnId) onCardMoved;
  final String Function(T item) idExtractor;
  final double cardSpacing;
  final Widget Function(String columnId)? emptyColumnBuilder;

  @override
  State<_KanbanColumnWidget<T>> createState() => _KanbanColumnWidgetState<T>();
}

class _KanbanColumnWidgetState<T> extends State<_KanbanColumnWidget<T>> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<_DragData<T>>(
      onWillAcceptWithDetails: (details) {
        if (details.data.fromColumnId == widget.column.id) return false;
        if (widget.column.maxItems != null &&
            widget.column.items.length >= widget.column.maxItems!) {
          return false;
        }
        setState(() => _isHovering = true);
        return true;
      },
      onLeave: (_) {
        setState(() => _isHovering = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isHovering = false);
        widget.onCardMoved(
          details.data.item,
          details.data.fromColumnId,
          widget.column.id,
        );
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          decoration: BoxDecoration(
            color: _isHovering
                ? (widget.column.backgroundColor ?? AppColors.background).withOpacity(0.8)
                : widget.column.backgroundColor ?? AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: _isHovering
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.border.withOpacity(0.5),
              width: _isHovering ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: [
                    if (widget.column.icon != null) ...[
                      Icon(
                        widget.column.icon,
                        size: 16,
                        color: widget.column.headerColor ?? AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (widget.column.headerColor != null)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: widget.column.headerColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      widget.column.title,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        '${widget.column.items.length}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Cards
              Expanded(
                child: widget.column.items.isEmpty
                    ? widget.emptyColumnBuilder?.call(widget.column.id) ??
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Text(
                              'No items',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        itemCount: widget.column.items.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: widget.cardSpacing),
                        itemBuilder: (context, index) {
                          final item = widget.column.items[index];
                          return _DraggableCard<T>(
                            item: item,
                            columnId: widget.column.id,
                            cardBuilder: widget.cardBuilder,
                            idExtractor: widget.idExtractor,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DraggableCard<T> extends StatelessWidget {
  const _DraggableCard({
    required this.item,
    required this.columnId,
    required this.cardBuilder,
    required this.idExtractor,
  });

  final T item;
  final String columnId;
  final Widget Function(T item, bool isDragging) cardBuilder;
  final String Function(T item) idExtractor;

  @override
  Widget build(BuildContext context) {
    return Draggable<_DragData<T>>(
      data: _DragData(item: item, fromColumnId: columnId),
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: SizedBox(
          width: 260,
          child: Opacity(
            opacity: 0.9,
            child: cardBuilder(item, true),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: cardBuilder(item, false),
      ),
      child: cardBuilder(item, false),
    );
  }
}

class _DragData<T> {
  const _DragData({
    required this.item,
    required this.fromColumnId,
  });

  final T item;
  final String fromColumnId;
}
