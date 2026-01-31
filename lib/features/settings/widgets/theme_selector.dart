import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/settings_providers.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeSettingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text('Appearance', style: AppTypography.labelMedium),
        ),
        Row(
          children: [
            const SizedBox(width: AppSpacing.md),
            _ThemeOption(
              icon: Icons.brightness_auto,
              label: 'System',
              isSelected: themeMode == ThemeMode.system,
              onTap: () => ref
                  .read(themeModeSettingProvider.notifier)
                  .setThemeMode(ThemeMode.system),
            ),
            const SizedBox(width: AppSpacing.sm),
            _ThemeOption(
              icon: Icons.light_mode,
              label: 'Light',
              isSelected: themeMode == ThemeMode.light,
              onTap: () => ref
                  .read(themeModeSettingProvider.notifier)
                  .setThemeMode(ThemeMode.light),
            ),
            const SizedBox(width: AppSpacing.sm),
            _ThemeOption(
              icon: Icons.dark_mode,
              label: 'Dark',
              isSelected: themeMode == ThemeMode.dark,
              onTap: () => ref
                  .read(themeModeSettingProvider.notifier)
                  .setThemeMode(ThemeMode.dark),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: isSelected ? Border.all(color: AppColors.primary) : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
