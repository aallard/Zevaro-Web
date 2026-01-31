import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class DecisionDescription extends StatelessWidget {
  final Decision decision;

  const DecisionDescription({
    super.key,
    required this.decision,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.md),
            Text(
              decision.description.isNotEmpty
                  ? decision.description
                  : 'No description provided.',
              style: AppTypography.bodyMedium.copyWith(
                color: decision.description.isNotEmpty
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
              value: _formatDate(decision.createdAt),
            ),
            const SizedBox(height: AppSpacing.sm),
            _MetadataRow(
              icon: Icons.update_outlined,
              label: 'Updated',
              value: _formatDate(decision.updatedAt),
            ),
            if (decision.decidedAt != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _MetadataRow(
                icon: Icons.check_circle_outline,
                label: 'Decided',
                value: _formatDate(decision.decidedAt!),
              ),
            ],
          ],
        ),
      ),
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
