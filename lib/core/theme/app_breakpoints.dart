import 'package:flutter/material.dart';

/// Responsive breakpoint constants for the Zevaro design system
class AppBreakpoints {
  AppBreakpoints._();

  /// Mobile phones (< 600px)
  static const double mobile = 600;

  /// Tablets (600px - 900px)
  static const double tablet = 900;

  /// Desktop (900px - 1200px)
  static const double desktop = 1200;

  /// Wide desktop (> 1200px)
  static const double wideDesktop = 1440;

  /// Check if the current width is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  /// Check if the current width is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  /// Check if the current width is desktop or wider
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  /// Check if the current width is wide desktop
  static bool isWideDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= wideDesktop;

  /// Get the number of grid columns based on width
  static int gridColumns(double width) {
    if (width >= wideDesktop) return 4;
    if (width >= desktop) return 3;
    if (width >= tablet) return 2;
    return 1;
  }
}

/// A responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.wideDesktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? wideDesktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.wideDesktop && wideDesktop != null) {
          return wideDesktop!;
        }
        if (constraints.maxWidth >= AppBreakpoints.tablet && desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= AppBreakpoints.mobile && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
