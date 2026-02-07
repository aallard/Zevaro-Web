import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class DecisionDescription extends StatefulWidget {
  final Decision decision;

  const DecisionDescription({
    super.key,
    required this.decision,
  });

  @override
  State<DecisionDescription> createState() => _DecisionDescriptionState();
}

class _DecisionDescriptionState extends State<DecisionDescription> {
  bool _showAllOptions = false;

  @override
  Widget build(BuildContext context) {
    final options = widget.decision.options ?? [];
    final displayedOptions = _showAllOptions ? options : options.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Context', style: AppTypography.h4),
                const SizedBox(height: AppSpacing.md),
                Text(
                  (widget.decision.context?.isNotEmpty ?? false)
                      ? widget.decision.context!
                      : (widget.decision.description?.isNotEmpty ?? false)
                          ? widget.decision.description!
                          : 'No context provided.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: (widget.decision.context?.isNotEmpty ?? false) ||
                            (widget.decision.description?.isNotEmpty ?? false)
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Divider(),
                const SizedBox(height: AppSpacing.md),

                // Metadata
                _MetadataRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Created',
                  value: _formatDate(widget.decision.createdAt),
                ),
                const SizedBox(height: AppSpacing.sm),
                _MetadataRow(
                  icon: Icons.update_outlined,
                  label: 'Updated',
                  value: _formatDate(widget.decision.updatedAt),
                ),
                if (widget.decision.decidedAt != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _MetadataRow(
                    icon: Icons.check_circle_outline,
                    label: 'Decided',
                    value: _formatDate(widget.decision.decidedAt!),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Options section
        if (options.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Options', style: AppTypography.h4),
                      const Spacer(),
                      if (options.length > 3)
                        GestureDetector(
                          onTap: () =>
                              setState(() => _showAllOptions = !_showAllOptions),
                          child: Text(
                            _showAllOptions ? 'Collapse <' : 'Expand >',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...displayedOptions.asMap().entries.map((e) {
                          final index = e.key;
                          final option = e.value;
                          final colors = [
                            AppColors.primary,
                            AppColors.success,
                            AppColors.warning,
                            AppColors.error,
                          ];
                          final dotColor = colors[index % colors.length];

                          return Padding(
                            padding: EdgeInsets.only(
                              right: index < displayedOptions.length - 1
                                  ? AppSpacing.md
                                  : 0,
                            ),
                            child: Container(
                              width: 240,
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: dotColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          option.title,
                                          style:
                                              AppTypography.labelMedium.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (option.description != null &&
                                      option.description!.isNotEmpty) ...[
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      option.description!,
                                      style: AppTypography.bodySmall,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  if (!_showAllOptions && options.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: Text(
                        '+${options.length - 3} more option${options.length - 3 > 1 ? 's' : ''}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

        // Blocked items section
        if (widget.decision.blockedItems != null &&
            widget.decision.blockedItems!.isNotEmpty)
          ...[
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Blocked Items', style: AppTypography.h4),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Expand >',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...widget.decision.blockedItems!.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          children: [
                            Icon(Icons.link_outlined,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                item,
                                style: AppTypography.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(value, style: AppTypography.bodySmall),
      ],
    );
  }
}
