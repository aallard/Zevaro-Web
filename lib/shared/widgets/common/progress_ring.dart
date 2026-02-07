import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zevaro_web/core/theme/app_colors.dart';
import 'package:zevaro_web/core/theme/app_typography.dart';

/// A circular progress ring with percentage in the center
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.percentage,
    this.size = 64,
    this.strokeWidth = 6,
    this.color,
    this.backgroundColor,
    this.showLabel = true,
    this.labelStyle,
  });

  final double percentage;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final bool showLabel;
  final TextStyle? labelStyle;

  Color get _effectiveColor {
    if (color != null) return color!;
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 50) return AppColors.primary;
    if (percentage >= 25) return AppColors.warning;
    return AppColors.textTertiary;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          percentage: percentage.clamp(0, 100),
          color: _effectiveColor,
          backgroundColor: backgroundColor ?? AppColors.border.withOpacity(0.3),
          strokeWidth: strokeWidth,
        ),
        child: showLabel
            ? Center(
                child: Text(
                  '${percentage.round()}%',
                  style: labelStyle ??
                      AppTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
              )
            : null,
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.percentage,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double percentage;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (percentage > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      final sweepAngle = (percentage / 100) * 2 * math.pi;
      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      percentage != oldDelegate.percentage ||
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth;
}
