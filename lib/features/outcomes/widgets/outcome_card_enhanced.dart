import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class OutcomeCardEnhanced extends StatelessWidget {
  final Outcome outcome;
  final VoidCallback? onTap;

  const OutcomeCardEnhanced({
    super.key,
    required this.outcome,
    this.onTap,
  });

  Color get _statusColor {
    switch (outcome.status) {
      case OutcomeStatus.VALIDATED:
        return AppColors.success;
      case OutcomeStatus.INVALIDATED:
        return AppColors.error;
      case OutcomeStatus.IN_PROGRESS:
      case OutcomeStatus.VALIDATING:
        return AppColors.warning;
      case OutcomeStatus.ABANDONED:
        return AppColors.textTertiary;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValidated = outcome.status == OutcomeStatus.VALIDATED;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isValidated
                ? AppColors.success.withOpacity(0.02)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: isValidated
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.border,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              // Progress ring with dynamic color
              SizedBox(
                width: 64,
                height: 64,
                child: _ProgressRing(
                  progress: outcome.validationRate / 100,
                  color: _getProgressRingColor(outcome.validationRate),
                  label: '${outcome.validationRate.toStringAsFixed(0)}%',
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Center content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status badge + title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _statusColor.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            outcome.status.displayName.toUpperCase(),
                            style: AppTypography.labelSmall.copyWith(
                              color: _statusColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      outcome.title,
                      style: AppTypography.h4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    if (outcome.description != null && outcome.description!.isNotEmpty)
                      Text(
                        outcome.description!,
                        style: AppTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: AppSpacing.xs),

                    // Hypothesis chips
                    _HypothesisChips(outcome: outcome),
                  ],
                ),
              ),

              // Right side: Owner + team + target date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (outcome.ownerName != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ZAvatar(
                          name: outcome.ownerName!,
                          imageUrl: outcome.ownerAvatarUrl,
                          size: 24,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(outcome.ownerName!,
                            style: AppTypography.labelSmall),
                      ],
                    ),
                  if (outcome.targetDate != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today,
                            size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(outcome.targetDate!),
                          style: AppTypography.labelSmall,
                        ),
                      ],
                    ),
                  ],
                  if (outcome.teamName != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline,
                            size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          outcome.teamName!,
                          style: AppTypography.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressRingColor(double validationRate) {
    if (validationRate >= 60) {
      return AppColors.success; // Green
    } else if (validationRate >= 30) {
      return AppColors.warning; // Amber
    } else {
      return AppColors.error; // Red
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress;
  final Color color;
  final String label;

  const _ProgressRing({
    required this.progress,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RingPainter(
        progress: progress.clamp(0, 1),
        color: color,
        trackColor: AppColors.surfaceVariant,
      ),
      child: Center(
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    const strokeWidth = 5.0;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.color != color;
}

class _HypothesisChips extends StatelessWidget {
  final Outcome outcome;

  const _HypothesisChips({required this.outcome});

  @override
  Widget build(BuildContext context) {
    final validatedCount = outcome.validatedHypothesisCount;
    final invalidatedCount = outcome.hypothesisCount -
        outcome.validatedHypothesisCount -
        outcome.activeHypothesisCount;
    final activeCount = outcome.activeHypothesisCount;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Validated
        if (validatedCount > 0)
          _HypothesisChip(
            icon: Icons.check_circle,
            label: 'Hypothesis',
            count: validatedCount,
            color: AppColors.success,
          ),
        if (validatedCount > 0) const SizedBox(width: AppSpacing.xxs),
        // Invalidated
        if (invalidatedCount > 0)
          _HypothesisChip(
            icon: Icons.cancel,
            label: 'Hypothesis',
            count: invalidatedCount,
            color: AppColors.error,
          ),
        if (invalidatedCount > 0) const SizedBox(width: AppSpacing.xxs),
        // Active
        if (activeCount > 0)
          _HypothesisChip(
            icon: Icons.link,
            label: 'Hypothesis',
            count: activeCount,
            color: AppColors.primary,
          ),
        const SizedBox(width: AppSpacing.xs),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Expand >',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _HypothesisChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _HypothesisChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
