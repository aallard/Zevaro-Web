import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Custom page transitions that are instant (no animation).
class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

abstract class AppTheme {
  /// Page transitions theme with no animations for all platforms.
  static const _noTransitions = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: NoTransitionsBuilder(),
      TargetPlatform.iOS: NoTransitionsBuilder(),
      TargetPlatform.linux: NoTransitionsBuilder(),
      TargetPlatform.macOS: NoTransitionsBuilder(),
      TargetPlatform.windows: NoTransitionsBuilder(),
      TargetPlatform.fuchsia: NoTransitionsBuilder(),
    },
  );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        pageTransitionsTheme: _noTransitions,

        // Colors
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.textOnPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.textOnPrimary,
          error: AppColors.error,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.background,

        // Typography
        textTheme: TextTheme(
          displayLarge: AppTypography.h1,
          displayMedium: AppTypography.h2,
          displaySmall: AppTypography.h3,
          headlineMedium: AppTypography.h4,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelMedium: AppTypography.labelMedium,
          labelSmall: AppTypography.labelSmall,
        ),

        // App Bar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.h4,
        ),

        // Cards
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            side: const BorderSide(color: AppColors.border),
          ),
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            textStyle: AppTypography.button,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            textStyle: AppTypography.button,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            textStyle: AppTypography.button,
          ),
        ),

        // Input
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
          labelStyle: AppTypography.labelMedium,
        ),

        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceVariant,
          labelStyle: AppTypography.labelMedium,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          thickness: 1,
          space: 1,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        pageTransitionsTheme: _noTransitions,

        // Colors
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          error: AppColors.error,
          surface: const Color(0xFF1E1E1E),
          onSurface: const Color(0xFFE0E0E0),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),

        // Typography
        textTheme: TextTheme(
          displayLarge: AppTypography.h1.copyWith(color: const Color(0xFFE0E0E0)),
          displayMedium: AppTypography.h2.copyWith(color: const Color(0xFFE0E0E0)),
          displaySmall: AppTypography.h3.copyWith(color: const Color(0xFFE0E0E0)),
          headlineMedium: AppTypography.h4.copyWith(color: const Color(0xFFE0E0E0)),
          bodyLarge: AppTypography.bodyLarge.copyWith(color: const Color(0xFFE0E0E0)),
          bodyMedium: AppTypography.bodyMedium.copyWith(color: const Color(0xFFE0E0E0)),
          bodySmall: AppTypography.bodySmall.copyWith(color: const Color(0xFFB0B0B0)),
          labelLarge: AppTypography.labelLarge.copyWith(color: const Color(0xFFE0E0E0)),
          labelMedium: AppTypography.labelMedium.copyWith(color: const Color(0xFFE0E0E0)),
          labelSmall: AppTypography.labelSmall.copyWith(color: const Color(0xFFB0B0B0)),
        ),

        // App Bar
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E),
          foregroundColor: const Color(0xFFE0E0E0),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.h4.copyWith(color: const Color(0xFFE0E0E0)),
        ),

        // Cards
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            textStyle: AppTypography.button,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            textStyle: AppTypography.button,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            textStyle: AppTypography.button,
          ),
        ),

        // Input
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.error),
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: const Color(0xFF9E9E9E),
          ),
          labelStyle: AppTypography.labelMedium.copyWith(
            color: const Color(0xFFB0B0B0),
          ),
        ),

        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF2C2C2C),
          labelStyle: AppTypography.labelMedium.copyWith(color: const Color(0xFFE0E0E0)),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: Color(0xFF2C2C2C),
          thickness: 1,
          space: 1,
        ),

        // Switch
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primary;
            }
            return const Color(0xFF9E9E9E);
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primary.withOpacity(0.5);
            }
            return const Color(0xFF3C3C3C);
          }),
        ),

        // ListTile
        listTileTheme: const ListTileThemeData(
          iconColor: Color(0xFFB0B0B0),
        ),

        // PopupMenu
        popupMenuTheme: PopupMenuThemeData(
          color: const Color(0xFF2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
        ),

        // BottomSheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF1E1E1E),
        ),

        // SnackBar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF323232),
          contentTextStyle: AppTypography.bodyMedium.copyWith(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
