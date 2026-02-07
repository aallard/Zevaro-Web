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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppConstants.tabletBreakpoint;

    return outcomeAsync.when(
      data: (outcome) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back
            TextButton.icon(
              onPressed: () => context.go(Routes.outcomes),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Outcomes'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Header
            _OutcomeHeader(outcome: outcome),
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
                        _DescriptionSection(outcome: outcome),
                        const SizedBox(height: AppSpacing.lg),
                        _KeyResultsSection(outcome: outcome),
                        const SizedBox(height: AppSpacing.lg),
                        _HypothesesSection(outcome: outcome),
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
              _DescriptionSection(outcome: outcome),
              const SizedBox(height: AppSpacing.lg),
              _KeyResultsSection(outcome: outcome),
              const SizedBox(height: AppSpacing.lg),
              _HypothesesSection(outcome: outcome),
            ],
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

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: AppSpacing.xs),
              Text(outcome.title, style: AppTypography.h2),
            ],
          ),
        ),
      ],
    );
  }
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
            ...keyResults.map((kr) => _KeyResultRow(keyResult: kr)),
        ],
      ),
    );
  }
}

class _KeyResultRow extends StatelessWidget {
  final KeyResult keyResult;

  const _KeyResultRow({required this.keyResult});

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
                child: Text(keyResult.description,
                    style: AppTypography.labelLarge),
              ),
              Text(
                '${keyResult.currentValue.toStringAsFixed(1)} / ${keyResult.targetValue.toStringAsFixed(1)} ${keyResult.unit}',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _HypothesesSection extends StatelessWidget {
  final Outcome outcome;

  const _HypothesesSection({required this.outcome});

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
          Text('Linked Hypotheses', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${outcome.hypothesisCount} total · '
            '${outcome.validatedHypothesisCount} validated · '
            '${outcome.activeHypothesisCount} active',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          // Summary stats
          Row(
            children: [
              _StatChip(
                label: 'Validated',
                count: outcome.validatedHypothesisCount,
                color: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.xs),
              _StatChip(
                label: 'Active',
                count: outcome.activeHypothesisCount,
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.xs),
              _StatChip(
                label: 'Failed',
                count: outcome.hypothesisCount -
                    outcome.validatedHypothesisCount -
                    outcome.activeHypothesisCount,
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            '$count $label',
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
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
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(outcome.ownerName ?? 'Unassigned',
                    style: AppTypography.bodyMedium),
              ],
            ),
          ),
          if (outcome.targetDate != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Target Date',
              child: Row(
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
            ),
          ],
          const Divider(height: AppSpacing.lg),
          _Field(
            label: 'Validation Rate',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                        child: LinearProgressIndicator(
                          value: outcome.validationRate / 100,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              _statusColor),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${outcome.validationRate.toStringAsFixed(0)}%',
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
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
