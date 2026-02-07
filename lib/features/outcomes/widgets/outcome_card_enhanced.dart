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
              // Progress ring
              SizedBox(
                width: 64,
                height: 64,
                child: _ProgressRing(
                  progress: outcome.validationRate / 100,
                  color: _statusColor,
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

                    // Stats row
                    Text(
                      '${outcome.hypothesisCount} Hypotheses · '
                      '${outcome.validatedHypothesisCount} Validated · '
                      '${outcome.activeHypothesisCount} Running',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),

              // Right side: Owner + target
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
