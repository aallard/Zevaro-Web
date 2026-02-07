import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../../../shared/widgets/common/avatar.dart';
import '../../hypotheses/widgets/create_hypothesis_dialog.dart';
import '../providers/outcomes_providers.dart';

class OutcomeDetailScreen extends ConsumerWidget {
  final String id;

  const OutcomeDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outcomeAsync = ref.watch(outcomeDetailProvider(id));
    final hypothesesAsync = ref.watch(outcomeHypothesesProvider(id));
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppConstants.tabletBreakpoint;

    return outcomeAsync.when(
      data: (outcome) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb navigation
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => context.go(Routes.outcomes),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Outcomes'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                  ),
                ),
                Text(
                  '/',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                Text(
                  ' ${outcome.title}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Header with badges
            _OutcomeHeader(outcome: outcome),
            const SizedBox(height: AppSpacing.lg),

            // Success Criteria section
            _SuccessCriteriaSection(outcome: outcome),
            const SizedBox(height: AppSpacing.lg),

            // Content
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _KeyResultsSection(outcome: outcome),
                        const SizedBox(height: AppSpacing.lg),
                        _HypothesesSection(
                          outcome: outcome,
                          hypothesesAsync: hypothesesAsync,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _DescriptionSection(outcome: outcome),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _SidebarPanel(outcome: outcome),
                  ),
                ],
              )
            else ...[
              _SidebarPanel(outcome: outcome),
              const SizedBox(height: AppSpacing.lg),
              _KeyResultsSection(outcome: outcome),
              const SizedBox(height: AppSpacing.lg),
              _HypothesesSection(
                outcome: outcome,
                hypothesesAsync: hypothesesAsync,
              ),
              const SizedBox(height: AppSpacing.lg),
              _DescriptionSection(outcome: outcome),
            ],

            // Footer
            const SizedBox(height: AppSpacing.lg),
            _DetailFooter(outcome: outcome),
          ],
        ),
      ),
      loading: () => const LoadingIndicator(message: 'Loading outcome...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(outcomeDetailProvider(id)),
      ),
    );
  }
}

class _OutcomeHeader extends StatelessWidget {
  final Outcome outcome;

  const _OutcomeHeader({required this.outcome});

  Color get _statusColor {
    switch (outcome.status) {
      case OutcomeStatus.VALIDATED:
        return AppColors.success;
      case OutcomeStatus.INVALIDATED:
        return AppColors.error;
      case OutcomeStatus.IN_PROGRESS:
      case OutcomeStatus.VALIDATING:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  Color get _priorityColor {
    switch (outcome.priority) {
      case OutcomePriority.CRITICAL:
        return AppColors.error;
      case OutcomePriority.HIGH:
        return AppColors.warning;
      case OutcomePriority.MEDIUM:
        return AppColors.primary;
      case OutcomePriority.LOW:
        return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges row
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                outcome.status.displayName.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                outcome.priority.displayName.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: _priorityColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(outcome.title, style: AppTypography.h2),
      ],
    );
  }
}

class _SuccessCriteriaSection extends StatelessWidget {
  final Outcome outcome;

  const _SuccessCriteriaSection({required this.outcome});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress ring on left
          SizedBox(
            width: 80,
            height: 80,
            child: _SuccessRing(
              progress: outcome.validationRate / 100,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Content on right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Success Criteria', style: AppTypography.h4),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${outcome.validationRate.toStringAsFixed(0)}% Validation Rate',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${outcome.validatedHypothesisCount} of ${outcome.hypothesisCount} hypotheses validated',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessRing extends StatelessWidget {
  final double progress;

  const _SuccessRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SuccessRingPainter(
        progress: progress.clamp(0, 1),
      ),
      child: Center(
        child: Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: AppTypography.metricSmall.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _SuccessRingPainter extends CustomPainter {
  final double progress;

  _SuccessRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 6;
    const strokeWidth = 6.0;

    // Track
    final trackPaint = Paint()
      ..color = AppColors.surfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = AppColors.primary
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
  bool shouldRepaint(covariant _SuccessRingPainter old) =>
      old.progress != progress;
}

class _DescriptionSection extends StatelessWidget {
  final Outcome outcome;

  const _DescriptionSection({required this.outcome});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.sm),
          Text(
            outcome.description ?? 'No description provided.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyResultsSection extends StatelessWidget {
  final Outcome outcome;

  const _KeyResultsSection({required this.outcome});

  @override
  Widget build(BuildContext context) {
    final keyResults = outcome.keyResults ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Results', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.md),
          if (keyResults.isEmpty)
            Text('No key results defined.',
                style: AppTypography.bodySmall)
          else
            ...keyResults.asMap().entries.map((entry) =>
              _KeyResultRow(
                number: entry.key + 1,
                keyResult: entry.value,
              ),
            ),
        ],
      ),
    );
  }
}

class _KeyResultRow extends StatelessWidget {
  final int number;
  final KeyResult keyResult;

  const _KeyResultRow({
    required this.number,
    required this.keyResult,
  });

  @override
  Widget build(BuildContext context) {
    final progress = keyResult.progressPercent / 100;
    final color = progress >= 1.0
        ? AppColors.success
        : progress >= 0.5
            ? AppColors.warning
            : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'KR$number. ${keyResult.description}',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${keyResult.progressPercent.toStringAsFixed(0)}% Complete',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${keyResult.currentValue.toStringAsFixed(1)} / ${keyResult.targetValue.toStringAsFixed(1)} ${keyResult.unit}',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HypothesesSection extends ConsumerWidget {
  final Outcome outcome;
  final AsyncValue<List<Hypothesis>> hypothesesAsync;

  const _HypothesesSection({
    required this.outcome,
    required this.hypothesesAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hypotheses', style: AppTypography.h4),
              TextButton.icon(
                onPressed: () => showCreateHypothesisDialog(context, outcome.id),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Hypothesis'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (outcome.hypothesisCount == 0)
            Text(
              'No hypotheses linked to this outcome yet.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            hypothesesAsync.when(
              data: (hypotheses) {
                if (hypotheses.isEmpty) {
                  return Text(
                    'No hypotheses found.',
                    style: AppTypography.bodySmall,
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.2,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hypotheses.length,
                  itemBuilder: (context, index) =>
                      _HypothesisCard(hypothesis: hypotheses[index]),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Text(
                'Error loading hypotheses',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HypothesisCard extends StatelessWidget {
  final Hypothesis hypothesis;

  const _HypothesisCard({required this.hypothesis});

  Color get _statusColor {
    switch (hypothesis.status) {
      case HypothesisStatus.VALIDATED:
        return AppColors.success;
      case HypothesisStatus.INVALIDATED:
        return AppColors.error;
      case HypothesisStatus.MEASURING:
        return AppColors.info;
      case HypothesisStatus.DEPLOYED:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: _statusColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              hypothesis.status.displayName,
              style: AppTypography.labelSmall.copyWith(
                color: _statusColor,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: Text(
              hypothesis.statement,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarPanel extends StatelessWidget {
  final Outcome outcome;

  const _SidebarPanel({required this.outcome});

  Color get _statusColor {
    switch (outcome.status) {
      case OutcomeStatus.VALIDATED:
        return AppColors.success;
      case OutcomeStatus.INVALIDATED:
        return AppColors.error;
      case OutcomeStatus.IN_PROGRESS:
      case OutcomeStatus.VALIDATING:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  String _getDaysRemaining() {
    if (outcome.targetDate == null) return 'Not set';
    final now = DateTime.now();
    final difference = outcome.targetDate!.difference(now).inDays;
    if (difference < 0) return 'Overdue by ${difference.abs()} days';
    if (difference == 0) return 'Due today';
    return '$difference days remaining';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(
            label: 'Status',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                outcome.status.displayName,
                style: AppTypography.labelMedium
                    .copyWith(color: _statusColor, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Divider(height: AppSpacing.lg),
          _Field(
            label: 'Priority',
            child: Text(outcome.priority.displayName,
                style: AppTypography.bodyMedium),
          ),
          const Divider(height: AppSpacing.lg),
          _Field(
            label: 'Owner',
            child: Row(
              children: [
                ZAvatar(
                  name: outcome.ownerName ?? 'Unassigned',
                  imageUrl: outcome.ownerAvatarUrl,
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(outcome.ownerName ?? 'Unassigned',
                      style: AppTypography.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          if (outcome.teamName != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Team',
              child: Text(outcome.teamName!,
                  style: AppTypography.bodyMedium),
            ),
          ],
          if (outcome.targetDate != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Target Date',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        _formatDate(outcome.targetDate!),
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _getDaysRemaining(),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Divider(height: AppSpacing.lg),
          _Field(
            label: 'Created Date',
            child: Row(
              children: [
                Icon(Icons.access_time,
                    size: 16, color: AppColors.textTertiary),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  _formatDate(outcome.createdAt),
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
          const Divider(height: AppSpacing.lg),
          _Field(
            label: 'Validated Hypotheses',
            child: Text(
              '${outcome.validatedHypothesisCount} of ${outcome.hypothesisCount}',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
          const Divider(height: AppSpacing.lg),
          _Field(
            label: 'Pending Decisions',
            child: Text(
              outcome.pendingDecisionCount.toString(),
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (outcome.project != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Project',
              child: Text(outcome.project!.name,
                  style: AppTypography.bodyMedium),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _Field extends StatelessWidget {
  final String label;
  final Widget child;

  const _Field({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.labelSmall
                .copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: AppSpacing.xxs),
        child,
      ],
    );
  }
}

class _DetailFooter extends StatelessWidget {
  final Outcome outcome;

  const _DetailFooter({required this.outcome});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Viewing Outcome',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            '${outcome.hypothesisCount} Hypotheses Validated (${outcome.validationRate.toStringAsFixed(0)}%) • '
            '${outcome.pendingDecisionCount} Pending Decisions • '
            'Target Date: ${_formatDate(outcome.targetDate)}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
