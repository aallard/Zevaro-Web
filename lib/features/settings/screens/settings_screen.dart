import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_selector.dart';
import '../widgets/notification_settings.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Section
          SettingsSection(
            title: 'Account',
            children: [
              SettingsTile(
                icon: Icons.person_outline,
                title: 'Profile',
                subtitle: 'Edit your name and avatar',
                onTap: () => context.go(Routes.profile),
              ),
              SettingsTile(
                icon: Icons.lock_outline,
                title: 'Change Password',
                onTap: () => _showChangePasswordDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Appearance Section
          SettingsSection(
            title: 'Appearance',
            children: const [
              ThemeSelector(),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Notifications Section
          SettingsSection(
            title: 'Notifications',
            children: const [
              NotificationSettingsWidget(),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Organization Section (if admin)
          userAsync.when(
            data: (user) {
              if (user.role.level >= 5) {
                return Column(
                  children: [
                    SettingsSection(
                      title: 'Organization',
                      children: [
                        SettingsTile(
                          icon: Icons.business_outlined,
                          title: 'Organization Settings',
                          subtitle: 'Manage your organization',
                          onTap: () {
                            // TODO: Navigate to org settings
                          },
                        ),
                        SettingsTile(
                          icon: Icons.people_outline,
                          title: 'Team Management',
                          onTap: () => context.go(Routes.teams),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // About Section
          SettingsSection(
            title: 'About',
            children: [
              SettingsTile(
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: AppConstants.appVersion,
              ),
              SettingsTile(
                icon: Icons.description_outlined,
                title: 'Documentation',
                onTap: () {
                  // TODO: Open docs URL
                },
              ),
              SettingsTile(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                onTap: () {
                  // TODO: Open feedback form
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
                icon: Icons.logout,
                title: 'Sign Out',
                isDestructive: true,
                onTap: () => _confirmSignOut(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }

              final success = await ref
                  .read(changePasswordProvider.notifier)
                  .changePassword(
                    currentController.text,
                    newController.text,
                  );

              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed')),
                  );
                }
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authServiceProvider).logout();
              if (context.mounted) {
                context.go(Routes.login);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
