import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../routes.dart';

class AuthGuard {
  final Ref ref;

  AuthGuard(this.ref);

  /// Redirect unauthenticated users to login
  String? redirect(BuildContext context, GoRouterState state) {
    final authState = ref.read(authStateProvider);
    final isAuthRoute = _isAuthRoute(state.matchedLocation);

    print('[AUTH_GUARD] Checking route: ${state.matchedLocation}');
    print('[AUTH_GUARD] Auth state: $authState');
    print('[AUTH_GUARD] Is loading: ${authState.isLoading}');
    print('[AUTH_GUARD] Is auth route: $isAuthRoute');

    // Safely check if authenticated using try-catch (extensions not available from SDK)
    bool isAuthenticated = false;
    if (!authState.isLoading) {
      try {
        isAuthenticated = authState.value == AuthStatus.authenticated;
      } catch (_) {
        isAuthenticated = false;
      }
    }
    // If loading and on protected route, redirect to login (will redirect back after auth completes)
    // If loading and on auth route, stay there
    print('[AUTH_GUARD] Is authenticated: $isAuthenticated');

    // Not authenticated and trying to access protected route
    if (!isAuthenticated && !isAuthRoute) {
      print('[AUTH_GUARD] Redirecting to login');
      return '${Routes.login}?redirect=${state.matchedLocation}';
    }

    // Authenticated and trying to access auth route
    if (isAuthenticated && isAuthRoute) {
      print('[AUTH_GUARD] Redirecting to projects');
      return Routes.projects;
    }

    print('[AUTH_GUARD] No redirect needed');
    return null;
  }

  bool _isAuthRoute(String location) {
    return location.startsWith(Routes.login) ||
        location.startsWith(Routes.register) ||
        location.startsWith(Routes.forgotPassword) ||
        location.startsWith(Routes.resetPassword);
  }
}
