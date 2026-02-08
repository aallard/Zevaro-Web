import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../features/auth/auth.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/decisions/decisions.dart';
import '../../features/experiments/experiments.dart';
import '../../features/hypotheses/hypotheses.dart';
import '../../features/outcomes/outcomes.dart';
import '../../features/portfolios/portfolios.dart';
import '../../features/programs/programs.dart';
import '../../features/requirements/requirements.dart';
import '../../features/settings/settings.dart';
import '../../features/specifications/specifications.dart';
import '../../features/workstreams/workstreams.dart';
import '../../features/stakeholders/stakeholders.dart';
import '../../features/teams/teams.dart';
import '../../shared/widgets/app_shell/app_shell.dart';
import '../../shared/widgets/common/error_screen.dart';
import 'guards/auth_guard.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// Creates a page with no transition animation.
Page<void> noTransitionPage(Widget child, GoRouterState state) {
  return NoTransitionPage<void>(
    key: state.pageKey,
    child: child,
  );
}

/// Notifier that triggers router refresh when auth state changes.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) {
      notifyListeners();
    });
  }
  final Ref _ref;
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authGuard = AuthGuard(ref);
  final authNotifier = AuthChangeNotifier(ref);

  ref.onDispose(() => authNotifier.dispose());

  return GoRouter(
    refreshListenable: authNotifier,
    initialLocation: Routes.programs,
    debugLogDiagnostics: true,
    redirect: authGuard.redirect,
    routes: [
      // Auth routes
      GoRoute(
        path: Routes.login,
        name: 'login',
        pageBuilder: (context, state) =>
            noTransitionPage(const LoginScreen(), state),
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        pageBuilder: (context, state) =>
            noTransitionPage(const RegisterScreen(), state),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) =>
            noTransitionPage(const ForgotPasswordScreen(), state),
      ),
      GoRoute(
        path: Routes.resetPassword,
        name: 'resetPassword',
        pageBuilder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return noTransitionPage(ResetPasswordScreen(token: token), state);
        },
      ),

      // Main app shell with navigation
      ShellRoute(
        builder: (context, state, child) {
          // Determine title based on route
          String title = 'Dashboard';
          final location = state.matchedLocation;
          if (location.startsWith('/programs')) {
            title = 'Programs';
          } else if (location.startsWith('/portfolios')) {
            title = 'Portfolios';
          } else if (location.startsWith('/decisions')) {
            title = 'Decision Queue';
          } else if (location.startsWith('/outcomes')) {
            title = 'Outcomes';
          } else if (location.startsWith('/hypotheses')) {
            title = 'Hypotheses';
          } else if (location.startsWith('/experiments')) {
            title = 'Experiments';
          } else if (location.startsWith('/workstreams')) {
            title = 'Workstreams';
          } else if (location.startsWith('/specifications')) {
            title = 'Specifications';
          } else if (location.startsWith('/requirements')) {
            title = 'Requirements';
          } else if (location.startsWith('/teams')) {
            title = 'Team';
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
          // Portfolios
          GoRoute(
            path: Routes.portfolios,
            name: 'portfolios',
            pageBuilder: (context, state) =>
                noTransitionPage(const PortfoliosScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'portfolioDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(PortfolioDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Programs
          GoRoute(
            path: Routes.programs,
            name: 'programs',
            pageBuilder: (context, state) =>
                noTransitionPage(const ProgramsScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'programDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(ProgramsScreen(programId: id), state);
                },
              ),
            ],
          ),

          // Dashboard
          GoRoute(
            path: Routes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) =>
                noTransitionPage(const DashboardScreen(), state),
          ),

          // Decisions (CORE)
          GoRoute(
            path: Routes.decisions,
            name: 'decisions',
            pageBuilder: (context, state) =>
                noTransitionPage(const DecisionsScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'decisionDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(DecisionDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Outcomes
          GoRoute(
            path: Routes.outcomes,
            name: 'outcomes',
            pageBuilder: (context, state) =>
                noTransitionPage(const OutcomesScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'outcomeDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(OutcomeDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Hypotheses
          GoRoute(
            path: Routes.hypotheses,
            name: 'hypotheses',
            pageBuilder: (context, state) =>
                noTransitionPage(const HypothesesScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'hypothesisDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(HypothesisDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Experiments
          GoRoute(
            path: Routes.experiments,
            name: 'experiments',
            pageBuilder: (context, state) =>
                noTransitionPage(const ExperimentsScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'experimentDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(ExperimentDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Workstreams
          GoRoute(
            path: Routes.workstreams,
            name: 'workstreams',
            pageBuilder: (context, state) =>
                noTransitionPage(const WorkstreamsScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'workstreamDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(WorkstreamDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Specifications
          GoRoute(
            path: Routes.specifications,
            name: 'specifications',
            pageBuilder: (context, state) =>
                noTransitionPage(const Scaffold(body: Center(child: Text('Specifications'))), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'specificationDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(SpecificationDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Requirements
          GoRoute(
            path: Routes.requirements,
            name: 'requirements',
            pageBuilder: (context, state) =>
                noTransitionPage(const Scaffold(body: Center(child: Text('Requirements'))), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'requirementDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(RequirementDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Teams
          GoRoute(
            path: Routes.teams,
            name: 'teams',
            pageBuilder: (context, state) =>
                noTransitionPage(const TeamsScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'teamDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(TeamDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Stakeholders
          GoRoute(
            path: Routes.stakeholders,
            name: 'stakeholders',
            pageBuilder: (context, state) =>
                noTransitionPage(const StakeholdersScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                name: 'stakeholderDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return noTransitionPage(StakeholderDetailScreen(id: id), state);
                },
              ),
            ],
          ),

          // Settings
          GoRoute(
            path: Routes.settings,
            name: 'settings',
            pageBuilder: (context, state) =>
                noTransitionPage(const SettingsScreen(), state),
          ),

          // Organization Settings
          GoRoute(
            path: Routes.organizationSettings,
            name: 'organizationSettings',
            pageBuilder: (context, state) =>
                noTransitionPage(const OrganizationSettingsScreen(), state),
          ),

          // Profile
          GoRoute(
            path: Routes.profile,
            name: 'profile',
            pageBuilder: (context, state) =>
                noTransitionPage(const ProfileScreen(), state),
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => noTransitionPage(
      NotFoundScreen(path: state.uri.toString()),
      state,
    ),
  );
}
