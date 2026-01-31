abstract class AppConstants {
  static const appName = 'Zevaro';
  static const appVersion = '1.0.0';

  // Animation durations
  static const animationFast = Duration(milliseconds: 150);
  static const animationNormal = Duration(milliseconds: 300);
  static const animationSlow = Duration(milliseconds: 500);

  // Debounce
  static const searchDebounce = Duration(milliseconds: 300);

  // Pagination
  static const defaultPageSize = 20;

  // Breakpoints
  static const mobileBreakpoint = 640.0;
  static const tabletBreakpoint = 1024.0;
  static const desktopBreakpoint = 1280.0;
}
