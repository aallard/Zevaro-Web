import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/auth.dart';
import '../../shared/widgets/app_shell/app_shell.dart';
import 'guards/auth_guard.dart';
import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authGuard = AuthGuard(ref);

  return GoRouter(
    initialLocation: Routes.dashboard,
    debugLogDiagnostics: true,
    redirect: authGuard.redirect,
    routes: [
      // Auth routes
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.resetPassword,
        name: 'resetPassword',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return ResetPasswordScreen(token: token);
        },
      ),

      // Main app shell with navigation
      ShellRoute(
        builder: (context, state, child) {
          // Determine title based on route
          String title = 'Dashboard';
          final location = state.matchedLocation;
          if (location.startsWith('/decisions')) {
            title = 'Decisions';
          } else if (location.startsWith('/outcomes')) {
            title = 'Outcomes';
          } else if (location.startsWith('/hypotheses')) {
            title = 'Hypotheses';
          } else if (location.startsWith('/teams')) {
            title = 'Teams';
          } else if (location.startsWith('/stakeholders')) {
            title = 'Stakeholders';
          } else if (location.startsWith('/settings')) {
            title = 'Settings';
          } else if (location.startsWith('/profile')) {
            title = 'Profile';
          }

          return AppShell(title: title, child: child);
        },
        routes: [
          // Dashboard
          GoRoute(
            path: Routes.dashboard,
            name: 'dashboard',
            builder: (context, state) =>
                const Placeholder(), // TODO: DashboardScreen
          ),

          // Decisions (CORE)
          GoRoute(
            path: Routes.decisions,
            name: 'decisions',
            builder: (context, state) =>
                const Placeholder(), // TODO: DecisionsScreen
            routes: [
              GoRoute(
                path: ':id',
                name: 'decisionDetail',
                builder: (context, state) {
                  // final id = state.pathParameters['id']!;
                  return const Placeholder(); // TODO: DecisionDetailScreen(id: id)
                },
              ),
            ],
          ),

          // Outcomes
          GoRoute(
            path: Routes.outcomes,
            name: 'outcomes',
            builder: (context, state) =>
                const Placeholder(), // TODO: OutcomesScreen
            routes: [
              GoRoute(
                path: ':id',
                name: 'outcomeDetail',
                builder: (context, state) {
                  // final id = state.pathParameters['id']!;
                  return const Placeholder(); // TODO: OutcomeDetailScreen(id: id)
                },
              ),
            ],
          ),

          // Hypotheses
          GoRoute(
            path: Routes.hypotheses,
            name: 'hypotheses',
            builder: (context, state) =>
                const Placeholder(), // TODO: HypothesesScreen
            routes: [
              GoRoute(
                path: ':id',
                name: 'hypothesisDetail',
                builder: (context, state) {
                  // final id = state.pathParameters['id']!;
                  return const Placeholder(); // TODO: HypothesisDetailScreen(id: id)
                },
              ),
            ],
          ),

          // Teams
          GoRoute(
            path: Routes.teams,
            name: 'teams',
            builder: (context, state) =>
                const Placeholder(), // TODO: TeamsScreen
            routes: [
              GoRoute(
                path: ':id',
                name: 'teamDetail',
                builder: (context, state) {
                  // final id = state.pathParameters['id']!;
                  return const Placeholder(); // TODO: TeamDetailScreen(id: id)
                },
              ),
            ],
          ),

          // Stakeholders
          GoRoute(
            path: Routes.stakeholders,
            name: 'stakeholders',
            builder: (context, state) =>
                const Placeholder(), // TODO: StakeholdersScreen
            routes: [
              GoRoute(
                path: ':id',
                name: 'stakeholderDetail',
                builder: (context, state) {
                  // final id = state.pathParameters['id']!;
                  return const Placeholder(); // TODO: StakeholderDetailScreen(id: id)
                },
              ),
            ],
          ),

          // Settings
          GoRoute(
            path: Routes.settings,
            name: 'settings',
            builder: (context, state) =>
                const Placeholder(), // TODO: SettingsScreen
          ),

          // Profile
          GoRoute(
            path: Routes.profile,
            name: 'profile',
            builder: (context, state) =>
                const Placeholder(), // TODO: ProfileScreen
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const Placeholder(), // TODO: ErrorScreen
  );
}
