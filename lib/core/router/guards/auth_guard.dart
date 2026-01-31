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
    final isAuthenticated = authState.value == AuthStatus.authenticated;
    final isAuthRoute = _isAuthRoute(state.matchedLocation);

    // Not authenticated and trying to access protected route
    if (!isAuthenticated && !isAuthRoute) {
      return '${Routes.login}?redirect=${state.matchedLocation}';
    }

    // Authenticated and trying to access auth route
    if (isAuthenticated && isAuthRoute) {
      return Routes.dashboard;
    }

    return null; // No redirect
  }

  bool _isAuthRoute(String location) {
    return location.startsWith(Routes.login) ||
        location.startsWith(Routes.register) ||
        location.startsWith(Routes.forgotPassword) ||
        location.startsWith(Routes.resetPassword);
  }
}
