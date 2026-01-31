# Zevaro-Web CONVENTIONS

> Flutter Web client for Zevaro - Primary browser-based UI

---

## Client Overview

| Property | Value |
|----------|-------|
| App Name | Zevaro Web |
| Platform | Web (Chrome, Edge, Safari, Firefox) |
| State Management | Riverpod 2.x (via SDK) |
| Routing | GoRouter |
| SDK | zevaro_sdk (Git dependency) |

---

## Project Structure

```
zevaro_web/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/
│   │   ├── app_config.dart          # Environment config
│   │   ├── routes.dart              # GoRouter configuration
│   │   ├── theme.dart               # App theme
│   │   └── providers.dart           # Provider overrides
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── dashboard/
│   │   │   └── dashboard_screen.dart
│   │   ├── outcomes/
│   │   │   ├── outcomes_list_screen.dart
│   │   │   ├── outcome_detail_screen.dart
│   │   │   └── outcome_form_screen.dart
│   │   ├── hypotheses/
│   │   │   ├── hypotheses_list_screen.dart
│   │   │   ├── hypothesis_detail_screen.dart
│   │   │   └── hypothesis_form_screen.dart
│   │   ├── decisions/
│   │   │   ├── decision_queue_screen.dart    # Kanban board
│   │   │   ├── decision_detail_screen.dart
│   │   │   ├── decision_form_screen.dart
│   │   │   └── my_decisions_screen.dart
│   │   ├── stakeholders/
│   │   │   ├── stakeholders_list_screen.dart
│   │   │   └── stakeholder_detail_screen.dart
│   │   ├── experiments/
│   │   │   ├── experiments_list_screen.dart
│   │   │   └── experiment_detail_screen.dart
│   │   ├── analytics/
│   │   │   └── analytics_dashboard_screen.dart
│   │   ├── settings/
│   │   │   ├── settings_screen.dart
│   │   │   ├── integrations_screen.dart
│   │   │   └── team_settings_screen.dart
│   │   └── shared/
│   │       ├── not_found_screen.dart
│   │       └── error_screen.dart
│   ├── widgets/
│   │   ├── layout/
│   │   │   ├── app_scaffold.dart        # Main layout with nav
│   │   │   ├── navigation_rail.dart     # Side navigation
│   │   │   ├── app_header.dart          # Top header
│   │   │   └── responsive_layout.dart   # Responsive breakpoints
│   │   ├── decisions/
│   │   │   ├── decision_kanban.dart
│   │   │   ├── decision_kanban_column.dart
│   │   │   └── decision_resolve_dialog.dart
│   │   ├── charts/
│   │   │   ├── decision_velocity_chart.dart
│   │   │   ├── outcome_funnel_chart.dart
│   │   │   └── stakeholder_response_chart.dart
│   │   └── forms/
│   │       ├── outcome_form.dart
│   │       ├── hypothesis_form.dart
│   │       └── decision_form.dart
│   └── platform/
│       └── web_storage.dart             # localStorage wrapper
├── web/
│   ├── index.html
│   ├── manifest.json
│   └── favicon.png
├── test/
├── pubspec.yaml
└── CONVENTIONS.md
```

---

## Configuration

### main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_sdk/zevaro_sdk.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'config/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final config = AppConfig.fromEnvironment();
  
  runApp(
    ProviderScope(
      overrides: [
        // Override SDK's apiClientProvider with configured instance
        apiClientProvider.overrideWithValue(
          ApiClient(baseUrl: config.apiBaseUrl),
        ),
        appConfigProvider.overrideWithValue(config),
      ],
      child: const ZevaroApp(),
    ),
  );
}
```

### app_config.dart

```dart
class AppConfig {
  final String apiBaseUrl;
  final String analyticsBaseUrl;
  final String wsBaseUrl;
  final bool isDevelopment;
  
  const AppConfig({
    required this.apiBaseUrl,
    required this.analyticsBaseUrl,
    required this.wsBaseUrl,
    required this.isDevelopment,
  });
  
  factory AppConfig.fromEnvironment() {
    const apiUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );
    const analyticsUrl = String.fromEnvironment(
      'ANALYTICS_BASE_URL',
      defaultValue: 'http://localhost:8081',
    );
    const wsUrl = String.fromEnvironment(
      'WS_BASE_URL',
      defaultValue: 'ws://localhost:8080/ws',
    );
    const isDev = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    ) == 'development';
    
    return AppConfig(
      apiBaseUrl: apiUrl,
      analyticsBaseUrl: analyticsUrl,
      wsBaseUrl: wsUrl,
      isDevelopment: isDev,
    );
  }
}

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
```

---

## Routing

### routes.dart

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      if (!isLoggedIn && !isAuthRoute) {
        return '/auth/login';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      // Auth routes (no scaffold)
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main app routes (with scaffold)
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          
          // Outcomes
          GoRoute(
            path: '/outcomes',
            builder: (context, state) => const OutcomesListScreen(),
          ),
          GoRoute(
            path: '/outcomes/new',
            builder: (context, state) => const OutcomeFormScreen(),
          ),
          GoRoute(
            path: '/outcomes/:id',
            builder: (context, state) => OutcomeDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/outcomes/:id/edit',
            builder: (context, state) => OutcomeFormScreen(
              id: state.pathParameters['id'],
            ),
          ),
          
          // Hypotheses
          GoRoute(
            path: '/hypotheses',
            builder: (context, state) => const HypothesesListScreen(),
          ),
          GoRoute(
            path: '/hypotheses/:id',
            builder: (context, state) => HypothesisDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),
          
          // Decisions (Core Feature)
          GoRoute(
            path: '/decisions',
            builder: (context, state) => const DecisionQueueScreen(),
          ),
          GoRoute(
            path: '/decisions/my-pending',
            builder: (context, state) => const MyDecisionsScreen(),
          ),
          GoRoute(
            path: '/decisions/:id',
            builder: (context, state) => DecisionDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),
          
          // Stakeholders
          GoRoute(
            path: '/stakeholders',
            builder: (context, state) => const StakeholdersListScreen(),
          ),
          
          // Analytics
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsDashboardScreen(),
          ),
          
          // Settings
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/settings/integrations',
            builder: (context, state) => const IntegrationsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
```

---

## Screen Pattern

### List Screen

```dart
class OutcomesListScreen extends ConsumerWidget {
  const OutcomesListScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outcomesAsync = ref.watch(outcomesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outcomes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/outcomes/new'),
          ),
        ],
      ),
      body: outcomesAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(outcomesProvider),
        ),
        data: (outcomes) {
          if (outcomes.isEmpty) {
            return const EmptyState(
              icon: Icons.flag_outlined,
              title: 'No outcomes yet',
              message: 'Create your first outcome to get started',
              actionLabel: 'Create Outcome',
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: outcomes.length,
            itemBuilder: (context, index) {
              final outcome = outcomes[index];
              return OutcomeCard(
                outcome: outcome,
                onTap: () => context.go('/outcomes/${outcome.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
```

### Detail Screen

```dart
class OutcomeDetailScreen extends ConsumerWidget {
  final String id;
  
  const OutcomeDetailScreen({super.key, required this.id});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outcomeAsync = ref.watch(outcomeByIdProvider(id));
    
    return outcomeAsync.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (error, stack) => Scaffold(
        body: ErrorDisplay(error: error),
      ),
      data: (outcome) => Scaffold(
        appBar: AppBar(
          title: Text(outcome.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.go('/outcomes/$id/edit'),
            ),
            PopupMenuButton<String>(
              onSelected: (action) => _handleAction(context, ref, action, outcome),
              itemBuilder: (context) => [
                if (outcome.status == OutcomeStatus.inExperiment)
                  const PopupMenuItem(
                    value: 'validate',
                    child: Text('Mark as Validated'),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusBadge(status: outcome.status),
              const SizedBox(height: 16),
              if (outcome.description != null)
                Text(outcome.description!),
              // ... more content
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Decision Queue (Kanban)

### decision_queue_screen.dart

```dart
class DecisionQueueScreen extends ConsumerWidget {
  const DecisionQueueScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(decisionQueueProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decision Queue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDecisionDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(decisionQueueProvider),
          ),
        ],
      ),
      body: queueAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(error: error),
        data: (queue) => DecisionKanban(
          needsInput: queue[DecisionStatus.needsInput] ?? [],
          discussing: queue[DecisionStatus.underDiscussion] ?? [],
          decided: queue[DecisionStatus.decided] ?? [],
          onDecisionTap: (d) => context.go('/decisions/${d.id}'),
          onResolve: (d) => _showResolveDialog(context, ref, d),
          onEscalate: (d) => _escalateDecision(ref, d),
        ),
      ),
    );
  }
}
```

### decision_kanban.dart

```dart
class DecisionKanban extends StatelessWidget {
  final List<Decision> needsInput;
  final List<Decision> discussing;
  final List<Decision> decided;
  final void Function(Decision) onDecisionTap;
  final void Function(Decision) onResolve;
  final void Function(Decision) onEscalate;
  
  const DecisionKanban({
    super.key,
    required this.needsInput,
    required this.discussing,
    required this.decided,
    required this.onDecisionTap,
    required this.onResolve,
    required this.onEscalate,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DecisionKanbanColumn(
            title: 'Needs Input',
            count: needsInput.length,
            color: Colors.red,
            decisions: needsInput,
            onDecisionTap: onDecisionTap,
            onResolve: onResolve,
            onEscalate: onEscalate,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DecisionKanbanColumn(
            title: 'Discussing',
            count: discussing.length,
            color: Colors.orange,
            decisions: discussing,
            onDecisionTap: onDecisionTap,
            onResolve: onResolve,
            onEscalate: onEscalate,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DecisionKanbanColumn(
            title: 'Decided',
            count: decided.length,
            color: Colors.green,
            decisions: decided,
            onDecisionTap: onDecisionTap,
            showTimer: false,
          ),
        ),
      ],
    );
  }
}
```

---

## Responsive Layout

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });
  
  static const mobileBreakpoint = 600.0;
  static const tabletBreakpoint = 900.0;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileBreakpoint) {
          return mobile;
        } else if (constraints.maxWidth < tabletBreakpoint) {
          return tablet ?? desktop;
        } else {
          return desktop;
        }
      },
    );
  }
}
```

---

## Theme

```dart
class ZevaroTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB), // Zevaro blue
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
      ),
    );
  }
  
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        brightness: Brightness.dark,
      ),
      // ... similar customizations
    );
  }
}
```

---

## pubspec.yaml

```yaml
name: zevaro_web
description: Zevaro Web Client - Continuous Outcome Engineering
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # SDK (shared code)
  zevaro_sdk:
    git:
      url: https://github.com/your-org/Zevaro-Flutter-SDK.git
      ref: main
  
  # Routing
  go_router: ^13.0.0
  
  # Charts
  fl_chart: ^0.66.0
  
  # Utilities
  url_launcher: ^6.2.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
```

---

## Build & Deploy

### Local Development

```bash
# Run in Chrome
flutter run -d chrome

# Run with specific API URL
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

### Production Build

```bash
# Build for web
flutter build web --release \
  --dart-define=API_BASE_URL=https://api.zevaro.ai \
  --dart-define=ANALYTICS_BASE_URL=https://analytics.zevaro.ai \
  --dart-define=ENVIRONMENT=production

# Output in build/web/
```

---

## Checklist for New Screen

- [ ] Create screen file in appropriate folder
- [ ] Add route in routes.dart
- [ ] Use SDK providers for data
- [ ] Handle loading/error/empty states
- [ ] Add to navigation (if top-level)
- [ ] Test responsive behavior
- [ ] Committed immediately after working
