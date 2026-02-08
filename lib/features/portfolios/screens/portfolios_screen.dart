import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/create_portfolio_dialog.dart';

class PortfoliosScreen extends ConsumerWidget {
  const PortfoliosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfoliosAsync = ref.watch(portfoliosProvider);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.md,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              Text('Portfolios', style: AppTypography.h2),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _showCreateDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Portfolio'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.sidebarAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: portfoliosAsync.when(
            data: (portfolios) {
              if (portfolios.isEmpty) {
                return _EmptyState(
                  onCreatePortfolio: () => _showCreateDialog(context),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 3
                      : constraints.maxWidth > 800
                          ? 2
                          : 1;

                  return GridView.builder(
                    padding:
                        const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 2.0,
                    ),
                    itemCount: portfolios.length,
                    itemBuilder: (context, index) =>
                        PortfolioCard(portfolio: portfolios[index]),
                  );
                },
              );
            },
            loading: () =>
                const LoadingIndicator(message: 'Loading portfolios...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(portfoliosProvider),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreatePortfolioDialog(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreatePortfolio;

  const _EmptyState({required this.onCreatePortfolio});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.business_center_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No portfolios yet',
            style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Create a portfolio to group and manage\nyour programs at a higher level.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onCreatePortfolio,
            icon: const Icon(Icons.add),
            label: const Text('Create Portfolio'),
          ),
        ],
      ),
    );
  }
}
