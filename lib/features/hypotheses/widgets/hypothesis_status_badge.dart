import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class HypothesisStatusBadge extends StatelessWidget {
  final HypothesisStatus status;
  final bool compact;

  const HypothesisStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(status.color.replaceFirst('#', '0xFF')));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? 2 : AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(_getIcon(), size: 14, color: color),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            status.displayName,
            style: (compact
                    ? AppTypography.labelSmall
                    : AppTypography.labelMedium)
                .copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (status) {
      case HypothesisStatus.DRAFT:
        return Icons.edit_outlined;
      case HypothesisStatus.READY:
        return Icons.check_circle_outline;
      case HypothesisStatus.BLOCKED:
        return Icons.block;
      case HypothesisStatus.BUILDING:
        return Icons.construction;
      case HypothesisStatus.DEPLOYED:
        return Icons.rocket_launch;
      case HypothesisStatus.MEASURING:
        return Icons.analytics;
      case HypothesisStatus.VALIDATED:
        return Icons.verified;
      case HypothesisStatus.INVALIDATED:
        return Icons.cancel;
    }
  }
}
