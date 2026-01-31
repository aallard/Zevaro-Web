import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class OrganizationSettingsScreen extends ConsumerWidget {
  const OrganizationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(currentTenantProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          TextButton.icon(
            onPressed: () => context.go(Routes.settings),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back to Settings'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          tenantAsync.when(
            data: (tenant) => Column(
              children: [
                // Organization Info
                SettingsSection(
                  title: 'Organization',
                  children: [
                    _OrganizationInfoCard(tenant: tenant),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Configuration
                SettingsSection(
                  title: 'Configuration',
                  children: [
                    SettingsTile(
                      icon: Icons.schedule_outlined,
                      title: 'SLA Settings',
                      subtitle: 'Configure decision response times',
                      onTap: () => _showSlaSettingsInfo(context, tenant),
                    ),
                    SettingsTile(
                      icon: Icons.security_outlined,
                      title: 'Security Settings',
                      subtitle: 'MFA and password policies',
                      onTap: () => _showSecuritySettingsInfo(context, tenant),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Billing (placeholder)
                SettingsSection(
                  title: 'Billing',
                  children: [
                    SettingsTile(
                      icon: Icons.credit_card_outlined,
                      title: 'Subscription',
                      subtitle: 'Manage your plan',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Billing portal coming soon')),
                        );
                      },
                    ),
                    SettingsTile(
                      icon: Icons.receipt_outlined,
                      title: 'Invoices',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invoices coming soon')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Danger Zone
                SettingsSection(
                  title: 'Danger Zone',
                  children: [
                    SettingsTile(
                      icon: Icons.delete_forever,
                      title: 'Delete Organization',
                      subtitle: 'Permanently delete all data',
                      isDestructive: true,
                      onTap: () => _confirmDeleteOrganization(context),
                    ),
                  ],
                ),
              ],
            ),
            loading: () =>
                const LoadingIndicator(message: 'Loading organization...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(currentTenantProvider),
            ),
          ),
        ],
      ),
    );
  }

  void _showSlaSettingsInfo(BuildContext context, Tenant tenant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SLA Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingRow(
                label: 'Blocking Priority',
                value: '${tenant.settings.blockingSlaHours} hours'),
            const SizedBox(height: AppSpacing.sm),
            _SettingRow(
                label: 'High Priority',
                value: '${tenant.settings.highSlaHours} hours'),
            const SizedBox(height: AppSpacing.sm),
            _SettingRow(
                label: 'Normal Priority',
                value: '${tenant.settings.normalSlaHours} hours'),
            const SizedBox(height: AppSpacing.sm),
            _SettingRow(
                label: 'Low Priority',
                value: '${tenant.settings.lowSlaHours} hours'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettingsInfo(BuildContext context, Tenant tenant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingRow(
              label: 'MFA Required',
              value: tenant.settings.requireMfa ? 'Yes' : 'No',
            ),
            const SizedBox(height: AppSpacing.sm),
            _SettingRow(
              label: 'Password Expiry',
              value: '${tenant.settings.passwordExpiryDays} days',
            ),
            const SizedBox(height: AppSpacing.sm),
            _SettingRow(
              label: 'Max Login Attempts',
              value: '${tenant.settings.maxLoginAttempts}',
            ),
            const SizedBox(height: AppSpacing.sm),
            _SettingRow(
              label: 'Audit Logging',
              value: tenant.settings.auditLoggingEnabled ? 'Enabled' : 'Disabled',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteOrganization(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Organization?'),
        content: const Text(
          'This will permanently delete your organization and all associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Please contact support to delete your organization')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _OrganizationInfoCard extends StatelessWidget {
  final Tenant tenant;

  const _OrganizationInfoCard({required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: tenant.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Image.network(
                      tenant.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          tenant.name.isNotEmpty
                              ? tenant.name[0].toUpperCase()
                              : 'O',
                          style:
                              AppTypography.h2.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      tenant.name.isNotEmpty
                          ? tenant.name[0].toUpperCase()
                          : 'O',
                      style: AppTypography.h2.copyWith(color: AppColors.primary),
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tenant.name, style: AppTypography.h3),
                Text(
                  tenant.slug,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (tenant.domain != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    tenant.domain!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: tenant.isActive
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              tenant.isActive ? 'Active' : 'Inactive',
              style: AppTypography.labelSmall.copyWith(
                color: tenant.isActive ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String value;

  const _SettingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(
          value,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
