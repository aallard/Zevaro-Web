import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';

class VersionHistoryPanel extends ConsumerWidget {
  final String documentId;

  const VersionHistoryPanel({super.key, required this.documentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionsAsync =
        ref.watch(documentVersionsProvider(documentId));

    return Container(
      width: 320,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          left: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text('Version History', style: AppTypography.h4),
          ),
          const Divider(height: 1),
          Expanded(
            child: versionsAsync.when(
              data: (versions) {
                if (versions.isEmpty) {
                  return Center(
                    child: Text(
                      'No version history',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: versions.length,
                  itemBuilder: (context, index) {
                    final version = versions[index];
                    return _VersionItem(version: version);
                  },
                );
              },
              loading: () => const LoadingIndicator(
                  message: 'Loading versions...'),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(
                    documentVersionsProvider(documentId)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionItem extends StatelessWidget {
  final DocumentVersion version;

  const _VersionItem({required this.version});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  'v${version.version}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              if (version.createdAt != null)
                Text(
                  _formatDate(version.createdAt!),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            version.title,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (version.editedByName != null)
            Text(
              'by ${version.editedByName!}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
