import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'portfolio_status_badge.dart';

class PortfolioCard extends StatelessWidget {
  final Portfolio portfolio;

  const PortfolioCard({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Routes.portfolioById(portfolio.id)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        portfolio.name,
                        style: AppTypography.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PortfolioStatusBadge(status: portfolio.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),

                // Description
                if (portfolio.description != null)
                  Text(
                    portfolio.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const Spacer(),

                // Stats row
                Row(
                  children: [
                    Icon(Icons.folder_outlined,
                        size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '${portfolio.programCount ?? 0} Programs',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (portfolio.ownerName != null) ...[
                      const SizedBox(width: AppSpacing.md),
                      Icon(Icons.person_outline,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: AppSpacing.xxs),
                      Expanded(
                        child: Text(
                          portfolio.ownerName!,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
