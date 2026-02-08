import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../common/badge.dart';
import 'user_menu.dart';

class AppHeader extends ConsumerWidget {
  final String title;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockingDecisions = ref.watch(blockingDecisionsProvider);

    return Container(
      height: AppSpacing.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Page title
          Text(title, style: AppTypography.h3),

          const Spacer(),

          // Search
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textSecondary),
            onPressed: () => context.go(Routes.search),
            tooltip: 'Search',
          ),

          // Quick actions
          if (actions != null) ...actions!,

          const SizedBox(width: AppSpacing.md),

          // Blocking decisions alert
          blockingDecisions.when(
            data: (decisions) {
              if (decisions.isEmpty) return const SizedBox.shrink();
              return Tooltip(
                message: '${decisions.length} blocking decision(s)',
                child: IconButton(
                  onPressed: () {
                    context.go(Routes.decisions);
                  },
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.error,
                      ),
                      Positioned(
                        right: -8,
                        top: -4,
                        child: ZBadge(count: decisions.length),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(width: AppSpacing.sm),

          // User menu
          const UserMenu(),
        ],
      ),
    );
  }
}
