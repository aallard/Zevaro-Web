import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/profile_form.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          // Profile form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: const ProfileForm(),
            ),
          ),
        ],
      ),
    );
  }
}
