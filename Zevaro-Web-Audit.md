# Zevaro-Web Comprehensive Audit

**Audit Date:** 2026-02-08
**Source Files:** 153 non-generated `.dart` files (~24,071 lines)
**Generated Files:** 12 `.g.dart` files (Riverpod code generation)

---

## 1. Project Overview

Zevaro-Web is a **Flutter web application** that serves as the primary browser-based UI for the Zevaro Continuous Outcome Engineering (COE) platform. It connects to the Zevaro-Core backend (Spring Boot, port 8080) via REST APIs exposed through the Zevaro-Flutter-SDK.

| Property | Value |
|---|---|
| Package Name | `zevaro_web` |
| Version | 1.0.0+1 |
| Dart SDK | `>=3.2.0 <4.0.0` |
| State Management | Riverpod 2.x (flutter_riverpod + riverpod_annotation + riverpod_generator) |
| Routing | GoRouter 17.x |
| API Layer | Zevaro-Flutter-SDK (local path dependency at `../Zevaro-Flutter-SDK`) |
| Design System | Material 3 with custom theme |
| Default API URL | `http://localhost:8080/api/v1` |
| Default Port | 3000 (Flutter web dev server) |

---

## 2. Architecture

### Directory Structure

```
lib/
  main.dart                          # Entry point, SDK config, ProviderScope
  app.dart                           # ZevaroApp - MaterialApp.router setup
  core/
    constants/
      app_constants.dart             # App name, version, animation durations, breakpoints, pagination
    router/
      app_router.dart                # GoRouter configuration, AuthChangeNotifier, ShellRoute
      routes.dart                    # Route path constants and helper methods
      guards/
        auth_guard.dart              # Auth redirect logic
    theme/
      app_breakpoints.dart           # Responsive breakpoints + ResponsiveBuilder widget
      app_colors.dart                # Complete color palette (brand, status, urgency, kanban, chart)
      app_spacing.dart               # 4px base unit spacing + sidebar/header dimensions
      app_theme.dart                 # Light + Dark ThemeData with no-transition pages
      app_typography.dart            # Inter font family, heading/body/label/metric styles
      theme_exports.dart             # Barrel export
  features/
    auth/                            # Authentication flow
    dashboard/                       # Project dashboard with metrics
    decisions/                       # Decision queue (kanban + list views)
    experiments/                     # Experiment tracking
    hypotheses/                      # Hypothesis lifecycle management
    outcomes/                        # Outcome + Key Results (OKR-like)
    projects/                        # Project listing and selection
    settings/                        # User, org, notification settings
    stakeholders/                    # Stakeholder engagement tracking
    teams/                           # Team management + member CRUD
  shared/
    extensions/                      # (empty - unused directory)
    providers/
      shell_providers.dart           # SidebarCollapsed, CurrentNavIndex
    widgets/
      app_shell/                     # AppShell, Sidebar, Header, UserMenu
      common/                        # 16 reusable widgets (avatar, badge, kanban, etc.)
```

### Pattern

Each feature module follows a consistent structure:

```
features/<name>/
  <name>.dart          # Barrel file exporting screens, widgets, providers
  providers/
    <name>_providers.dart     # Riverpod notifiers, filter states, CRUD actions
    <name>_providers.g.dart   # Generated code
  screens/
    <name>_screen.dart        # List/main screen
    <name>_detail_screen.dart # Detail screen (where applicable)
  widgets/
    *.dart                    # Feature-specific UI widgets
```

---

## 3. Dependencies

### Runtime Dependencies

| Package | Version | Purpose |
|---|---|---|
| `zevaro_flutter_sdk` | local path | API client, models, Riverpod providers for all Zevaro services |
| `flutter_riverpod` | ^2.4.10 | State management |
| `riverpod_annotation` | ^2.3.4 | Code generation annotations for Riverpod |
| `go_router` | ^17.0.1 | Declarative routing with auth guards |
| `flutter_svg` | ^2.0.10 | SVG rendering (imported but no SVGs in assets) |
| `cached_network_image` | ^3.3.1 | Cached image loading (imported but not directly used in code) |
| `shimmer` | ^3.0.0 | Loading placeholder animations |
| `intl` | ^0.19.0 | Date/number formatting |
| `url_launcher` | ^6.2.4 | External URL launching (docs link in settings) |
| `shared_preferences` | ^2.2.2 | Local storage for theme mode and notification preferences |

### Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_test` | SDK | Testing framework |
| `flutter_lints` | ^6.0.0 | Static analysis linting |
| `build_runner` | ^2.4.8 | Code generation runner |
| `riverpod_generator` | ^2.3.11 | Generates Riverpod provider code |

---

## 4. Routing

### Route Definitions (`lib/core/router/routes.dart`)

| Route Path | Name | Screen | Detail Route |
|---|---|---|---|
| `/login` | login | LoginScreen | - |
| `/register` | register | RegisterScreen | - |
| `/forgot-password` | forgotPassword | ForgotPasswordScreen | - |
| `/reset-password` | resetPassword | ResetPasswordScreen | `?token=` query param |
| `/projects` | projects | ProjectsScreen | `/projects/:id` |
| `/` | dashboard | DashboardScreen | - |
| `/decisions` | decisions | DecisionsScreen | `/decisions/:id` |
| `/outcomes` | outcomes | OutcomesScreen | `/outcomes/:id` |
| `/hypotheses` | hypotheses | HypothesesScreen | `/hypotheses/:id` |
| `/experiments` | experiments | ExperimentsScreen | `/experiments/:id` |
| `/teams` | teams | TeamsScreen | `/teams/:id` |
| `/stakeholders` | stakeholders | StakeholdersScreen | `/stakeholders/:id` |
| `/settings` | settings | SettingsScreen | - |
| `/settings/organization` | organizationSettings | OrganizationSettingsScreen | - |
| `/profile` | profile | ProfileScreen | - |

### Router Configuration

- **Initial location:** `/projects` (not `/` dashboard -- this is intentional, projects is the entry point)
- **Auth guard:** `AuthGuard` class checks `authStateProvider` and redirects unauthenticated users to `/login?redirect=<path>`
- **Auth change notifier:** `AuthChangeNotifier` listens to `authStateProvider` and triggers router refresh
- **Page transitions:** All transitions disabled (`NoTransitionPage`) for web-like SPA feel
- **Shell route:** All authenticated routes are nested under a `ShellRoute` that wraps content in `AppShell` (sidebar + header)
- **Error page:** `NotFoundScreen` shown for unknown routes
- **Title derivation:** AppShell title is derived from the current route path in the `ShellRoute.builder` callback

### Auth Guard Behavior

1. Unauthenticated + protected route -> redirect to `/login?redirect=<current_path>`
2. Authenticated + auth route -> redirect to `/projects`
3. Loading + protected route -> redirect to login (will bounce back after auth resolves)
4. Otherwise -> no redirect

---

## 5. Features

### 5.1 Auth (`lib/features/auth/`)

**Screens (4):**
- `LoginScreen` - Email/password form, error handling, redirect support via query param
- `RegisterScreen` - Full registration with "New organization" vs "I have an invite" toggle
- `ForgotPasswordScreen` - Email submission with success state showing "Check your email"
- `ResetPasswordScreen` - Token-based password reset with confirmation

**Widgets (4):**
- `AuthHeader` - Logo ("Z" box + "Zevaro" text), title, subtitle
- `AuthFormField` - Label + TextFormField with password toggle support
- `AuthButton` - Full-width ElevatedButton or OutlinedButton with loading spinner
- `SocialAuthButton` - Outlined button with icon (prepared but not currently used in any screen)

**Providers:**
- `LoginFormState` - Async notifier calling `authStateProvider.notifier.login()`
- `RegisterFormState` - Calls `authService.register()`
- `ForgotPasswordFormState` - Calls `authService.forgotPassword()`
- `ResetPasswordFormState` - Calls `authService.resetPassword()`
- `AuthValidators` - Static validation methods (email regex, password, confirmPassword, required)

### 5.2 Dashboard (`lib/features/dashboard/`)

**Screens (1):**
- `DashboardScreen` - Shows "Select a project" if none selected; otherwise loads `ProjectDashboard` from SDK

**Widgets (8):**
- `MetricCard` - Stat card with icon, value, subtitle, trend indicator
- `DecisionQueuePanel` - Shows pending decisions in a panel
- `DecisionQueuePreview` - Compact decision queue preview
- `DecisionVelocityChart` - Chart panel for decision metrics over time
- `OutcomesProgressPanel` - Shows outcome progress bars
- `ActivityFeedPanel` - Recent activity timeline
- `MyPendingResponses` - User's pending decision responses
- `QuickActions` - Action shortcuts
- `StatCard` - Simple stat display

**Providers:**
- `dashboardStats` - Aggregates data from multiple SDK providers (decisions, blocking decisions, pending responses, outcomes, hypotheses)
- `DashboardStats` - Local data class with `hasUrgentItems` computed property

**Dashboard Layout:**
- Row 1: Four metric cards (Pending Decisions, Active Outcomes, Running Experiments, Avg Decision Time)
- Row 2: Decision Queue Panel (3/5 width) + Decision Velocity Chart (2/5 width)
- Row 3: Outcomes Progress Panel + Activity Feed Panel
- Responsive: stacks vertically below 900px width

### 5.3 Projects (`lib/features/projects/`)

**Screens (1):**
- `ProjectsScreen` - Card grid or list view with search, filter pills (by status), sort dropdown, and "New Project" button

**Widgets (4):**
- `ProjectCard` - Project card with color accent, stats summary
- `ProjectListView` - Table/list view of projects
- `ProjectFiltersBar` - Status filter pills
- `CreateProjectDialog` - Dialog for creating a new project

**Providers:**
- `ProjectViewModeNotifier` - Toggles between `card` and `list` view
- `ProjectFilters` - Status and search filter state
- `filteredProjects` - Fetches from `projectServiceProvider` with filter application
- `CreateProject` - Async action calling `projectService.createProject()`

### 5.4 Decisions (`lib/features/decisions/`)

**Screens (2):**
- `DecisionsScreen` - Board (kanban) or list view with filter pills (All Types, My Decisions, Blocking), search bar, sort, view toggle, and "New Decision" button
- `DecisionDetailScreen` - Two-column layout (wide) or single column (narrow) with back button, header, description, votes, comments, sidebar panel, and resolve button

**Widgets (16):**
- `CreateDecisionDialog` - Form for new decisions
- `DecisionBoard` - Kanban board view using `DraggableKanban`
- `DecisionColumn` - Individual kanban column
- `DecisionCard` - Card shown in board/list
- `DecisionList` - List view of decisions
- `DecisionListItem` - Row in the list view
- `DecisionFilters` - Filter bar for decisions
- `DecisionHeader` - Title, urgency badge, SLA, escalate button
- `DecisionDescription` - Markdown/text description panel
- `DecisionSidebarPanel` - Metadata sidebar (assignee, team, dates, type)
- `DecisionVotes` - Vote summary and voting interface
- `DecisionComments` - Comment thread with reply support
- `DecisionResolution` - Resolution dialog/form
- `UrgencyBadge` - Color-coded urgency indicator
- `SlaIndicator` - SLA countdown/breach indicator
- `VoteCard` / `CommentCard` - Individual vote and comment display

**Providers:**
- `DecisionViewMode` - Board vs List toggle
- `DecisionFilters` / `DecisionFilterState` - Urgency, type, team, search filters with `copyWith` and clear support
- `decisionsByStatus` - Groups decisions by status (NEEDS_INPUT, UNDER_DISCUSSION, DECIDED) with filter application
- `CreateDecision` - Creates decision and invalidates related providers
- `decisionDetail` - Fetches single decision with details
- `VoteOnDecision` - Vote action with provider invalidation
- `ResolveDecisionAction` - Resolve action
- `AddDecisionComment` - Comment action

### 5.5 Outcomes (`lib/features/outcomes/`)

**Screens (2):**
- `OutcomesScreen` - List view with filters
- `OutcomeDetailScreen` - Detail view with key results

**Widgets (10):**
- `CreateOutcomeDialog` - New outcome form
- `AddKeyResultDialog` - Add key result to an outcome
- `OutcomeCard` / `OutcomeCardEnhanced` - Outcome display cards (two variants)
- `OutcomeList` - List layout
- `OutcomeFilters` - Filter bar
- `OutcomeStatusBadge` - Status indicator
- `OutcomeKeyResults` - Key results section
- `KeyResultCard` - Individual key result display
- `KeyResultProgress` - Progress bar for key results

**Providers:**
- `OutcomeFilters` / `OutcomeFilterState` - Status, priority, team, search filters
- `filteredOutcomes` - Fetches with server-side filters + client-side search
- `outcomeDetail` - Single outcome with key results
- `outcomeHypotheses` - Hypotheses linked to an outcome
- `CreateOutcome` - Create action
- `UpdateOutcomeStatus` - Status transition
- `UpdateKeyResultProgress` - Progress update
- `AddKeyResult` - Add key result to outcome

### 5.6 Hypotheses (`lib/features/hypotheses/`)

**Screens (2):**
- `HypothesesScreen` - List/kanban view with filters
- `HypothesisDetailScreen` - Detail view with workflow, blocking info

**Widgets (10):**
- `CreateHypothesisDialog` - New hypothesis form
- `HypothesisCard` / `HypothesisCardEnhanced` - Two card variants
- `HypothesisList` - List layout
- `HypothesisKanban` - Kanban board view grouped by lifecycle status
- `HypothesisFilters` - Filter bar
- `HypothesisStatusBadge` - Status indicator
- `HypothesisEffortImpact` - Effort/impact scoring display
- `HypothesisBlocking` - Shows blocking decision information
- `HypothesisWorkflow` - Status transition workflow visualization

**Providers:**
- `HypothesisFilters` / `HypothesisFilterState` - Status, outcome, team, blocked-only, search
- `filteredHypotheses` - Fetches and filters, sorts by priority score
- `hypothesisDetail` - Single hypothesis with metrics
- `TransitionHypothesisStatus` - Status transition action
- `ValidateHypothesis` - Terminal success state
- `InvalidateHypothesis` - Terminal failure state
- `CreateHypothesis` - Create action
- `hypothesisList` - For kanban board
- `hypothesis` - Simple single fetch
- `hypothesisExperiments` - Stub (returns empty list, marked TODO)

### 5.7 Experiments (`lib/features/experiments/`)

**Screens (2):**
- `ExperimentsScreen` - List view with tab filters (Running, Completed, Draft)
- `ExperimentDetailScreen` - Detail view

**Widgets (1):**
- `ExperimentCard` - Experiment display card

**Providers:**
- `ExperimentFilterNotifier` - Tab state (running/completed/draft)
- `filteredExperiments` - Fetches by status and selected project
- `allExperiments` - All experiments for summary stats
- `experimentDetail` - Single experiment fetch

### 5.8 Teams (`lib/features/teams/`)

**Screens (2):**
- `TeamsScreen` - Team listing
- `TeamDetailScreen` - Team detail with member management

**Widgets (8):**
- `CreateTeamDialog` - New team form
- `InviteMemberDialog` - Add member to team
- `TeamCard` - Team display card
- `TeamList` - List of teams (exported as `TeamListWidget`)
- `TeamMemberCard` - Individual team member
- `MemberTable` - Tabular member display
- `StakeholderScorecard` - Stakeholder metrics card
- `WorkloadMatrix` - Team workload visualization

**Providers:**
- `teamsList` - All visible teams
- `teamDetail` - Team with members
- `AddTeamMember` - Add member action
- `UpdateMemberRole` - Role change action
- `RemoveTeamMember` - Remove action
- `CreateTeam` - Create action
- `availableUsers` - Users not yet in a team (for invite dialog)
- `teamMembersWithStats` - Members with statistics (uses first team only)
- `teamStakeholders` - Stakeholders associated with team

### 5.9 Stakeholders (`lib/features/stakeholders/`)

**Screens (2):**
- `StakeholdersScreen` - Stakeholder overview/leaderboard
- `StakeholderDetailScreen` - Individual stakeholder detail

**Widgets (6):**
- `StakeholderLeaderboard` - Ranked list of stakeholders by engagement
- `LeaderboardEntry` - Individual leaderboard row
- `SlowRespondersCard` - Highlights slow responders
- `StakeholderStatsCard` - Engagement statistics
- `PendingResponsesCard` - Pending response list
- `ResponseHistoryCard` - Past response timeline

**Providers:**
- `LeaderboardPeriod` - Period selection (default "30d")
- `stakeholderDetail` - Stakeholder with stats
- `myStakeholderProfile` - Current user's stakeholder profile
- `SendReminder` - Reminder action
- `stakeholderPendingResponses` - Pending responses for a stakeholder
- `stakeholderResponseHistory` - Completed responses

### 5.10 Settings (`lib/features/settings/`)

**Screens (3):**
- `SettingsScreen` - Main settings page with sections: Account, Appearance, Notifications, Organization (admin only), About, Danger Zone
- `ProfileScreen` - Profile editing form
- `OrganizationSettingsScreen` - Org info, SLA settings, security settings, billing (placeholder), delete org

**Widgets (6):**
- `SettingsSection` - Section header with child tiles
- `SettingsTile` - Individual setting row with icon, title, subtitle, tap handler, destructive style
- `ThemeSelector` - Theme mode picker (Light/Dark/System)
- `NotificationSettingsWidget` - Toggle switches for email/push notifications
- `ProfileForm` - Name, email, avatar editing form
- `FeedbackDialog` - Send feedback dialog

**Providers:**
- `ThemeModeSetting` - Persisted to SharedPreferences, defaults to `ThemeMode.light`
- `NotificationSettings` / `NotificationPrefs` - Four toggle preferences persisted to SharedPreferences
- `UpdateProfile` - Calls `userService.updateProfile()`
- `ChangePassword` - Calls `authService.changePassword()`

---

## 6. State Management

### Provider Architecture

The app uses **Riverpod 2.x** with code generation (`@riverpod` annotations). State flows in this hierarchy:

1. **SDK Providers** (from `zevaro_flutter_sdk`) - These are the foundation:
   - `authStateProvider` / `authServiceProvider` - Authentication
   - `currentUserProvider` / `userServiceProvider` - User data
   - `currentTenantProvider` - Tenant/organization data
   - `selectedProjectIdProvider` / `selectedProjectProvider` - Current project context
   - `decisionQueueProvider` / `decisionServiceProvider` - Decision CRUD
   - `blockingDecisionsProvider` - Blocking decisions alert
   - `myPendingResponsesProvider` - User's pending responses
   - `myOutcomesProvider` / `outcomeServiceProvider` - Outcome CRUD
   - `myHypothesesProvider` / `hypothesisServiceProvider` - Hypothesis CRUD
   - `blockedHypothesesProvider` - Blocked hypotheses
   - `experimentServiceProvider` - Experiment CRUD
   - `teamServiceProvider` / `myTeamsProvider` - Team CRUD
   - `stakeholderServiceProvider` - Stakeholder CRUD
   - `projectServiceProvider` - Project CRUD
   - `projectDashboardProvider` - Dashboard data
   - `decisionActionsProvider` - Decision workflow actions
   - `sdkConfigNotifierProvider` - SDK configuration

2. **Feature Providers** (Web-specific) - Filter states, view modes, action notifiers:
   - Each feature has filter state notifiers (e.g., `DecisionFilters`, `OutcomeFilters`)
   - View mode toggles (e.g., `DecisionViewMode`, `ProjectViewModeNotifier`)
   - CRUD action notifiers that call SDK services and invalidate related providers
   - Computed/aggregated providers (e.g., `decisionsByStatus`, `filteredOutcomes`)

3. **Shell Providers** - UI state:
   - `SidebarCollapsed` - Sidebar expand/collapse
   - `CurrentNavIndex` - Navigation highlight index

### State Flow Pattern

```
User Action -> Widget calls ref.read(actionProvider.notifier).doThing()
           -> Action notifier sets loading state
           -> Calls SDK service method
           -> On success: invalidates related data providers, returns result
           -> On failure: sets error state
           -> Watchers of data providers automatically re-fetch and rebuild UI
```

### Provider Configuration

The SDK's `sdkConfigNotifierProvider` is overridden in `main.dart` with a `_ConfiguredSdkConfigNotifier` that returns environment-specific `SdkConfig` (API base URL, logging flag). The `ProviderScope` wraps the entire app.

---

## 7. Theme

### Color System (`AppColors`)

**Brand:**
- Primary: `#3B82F6` (Blue) with dark/light variants
- Secondary: `#8B5CF6` (Purple) with dark/light variants
- Accent (used in buttons/sidebar): `#4F46E5` (Deep Indigo) -- Note: this differs from `primary`

**Status:**
- Success: `#10B981` (Green)
- Warning: `#F59E0B` (Amber)
- Error: `#EF4444` (Red)
- Info: `#06B6D4` (Cyan)

**Decision Urgency:** Blocking (Red) > High (Amber) > Normal (Blue) > Low (Gray)

**Hypothesis Status:** 8 distinct colors for lifecycle states (Draft gray, Ready blue, Blocked red, Building purple, Deployed amber, Measuring cyan, Validated green, Invalidated gray)

**Neutrals:** Background `#F9FAFB`, Surface `#FFFFFF`, Border `#E5E7EB`, Text Primary `#111827`, Text Secondary `#6B7280`, Text Tertiary `#9CA3AF`

**Sidebar:** Dark charcoal background `#1F2937` with hover `#374151`, indigo accent `#4F46E5`

**Specialty:** Kanban column backgrounds (very subtle tints), chart colors (5 colors), project accent colors (8 colors), experiment type colors (4 colors)

### Typography (`AppTypography`)

- **Font Family:** Inter (primary), JetBrains Mono (code)
- **Headings:** h1 (32px/700), h2 (24px/600), h3 (20px/600), h4 (18px/600)
- **Body:** bodyLarge (16px/400), bodyMedium (14px/400), bodySmall (12px/400)
- **Labels:** labelLarge (14px/500), labelMedium (12px/500), labelSmall (11px/500)
- **Special:** button (14px/600), code (13px/400 JetBrains Mono), caption (11px/400), metric (28px/700), metricSmall (20px/600)

### Spacing (`AppSpacing`)

- **Base unit:** 4px
- **Scale:** xxs(4), xs(8), sm(12), md(16), lg(24), xl(32), xxl(48), xxxl(64)
- **Border Radius:** sm(4), md(8), lg(12), xl(16), full(9999)
- **Layout:** sidebarWidth(256), sidebarCollapsedWidth(72), headerHeight(64), pagePadding(24)

### Breakpoints (`AppBreakpoints` + `AppConstants`)

Two overlapping breakpoint systems exist:

`AppBreakpoints` class: mobile(600), tablet(900), desktop(1200), wideDesktop(1440)
`AppConstants` class: mobile(640), tablet(1024), desktop(1280)

The `AppShell` uses `AppConstants.tabletBreakpoint` (1024) for mobile/desktop layout switching.
The `AppBreakpoints` class includes a `ResponsiveBuilder` widget and `gridColumns()` helper.

### Theme Variants

Both light and dark `ThemeData` are defined in `AppTheme`. The dark theme is fully specified with custom colors for all components. However, `app.dart` forces `themeMode: ThemeMode.light` regardless of the `themeModeSettingProvider` value, so dark mode is effectively disabled at the app level.

---

## 8. Shared Widgets

### App Shell (`lib/shared/widgets/app_shell/`)

- **`AppShell`** - Main layout wrapper. Desktop: persistent sidebar + header + content. Mobile (<1024px): Drawer-based sidebar with AppBar.
- **`Sidebar`** - Dark-themed navigation with: Logo, project selector, nav items (Projects, Decision Queue, Outcomes, Hypotheses, Experiments, Team), settings, user profile at bottom. Supports collapsed state (72px) with icons only.
- **`AppHeader`** - Top header bar with page title, blocking decisions alert badge, and user menu.
- **`UserMenu`** - Dropdown with Profile, Settings, Sign Out options. Shows user avatar, name, and role.
- **`SidebarItem`** - Standalone sidebar navigation item with badge support (appears unused -- `_SidebarNavItem` is used instead inline in `Sidebar`).
- **`SidebarSection`** - Group header for sidebar items (appears unused in current sidebar implementation).

### Common Widgets (`lib/shared/widgets/common/`)

| Widget | Purpose |
|---|---|
| `ZAvatar` | Circular avatar with image URL fallback to initials |
| `ZBadge` | Numeric badge (max "99+") with color customization |
| `ColorDot` | Small colored circle indicator |
| `DraggableKanban<T>` | Generic kanban board with drag-and-drop (`Draggable`/`DragTarget`), column configuration, responsive widths |
| `EmptyState` | Empty state display with icon, title, subtitle, action button; supports compact mode |
| `ErrorScreen` | Full-page error with retry + go home buttons |
| `NotFoundScreen` | 404 page with path display |
| `ErrorView` | Inline error display with retry |
| `FilterBar` | Pill-style filter chips with optional search field |
| `InfoRow` | Key-value row for detail panels |
| `LoadingIndicator` | Centered spinner with optional message |
| `PageScaffold` | Page wrapper with title, subtitle, actions, body |
| `ProgressRing` | Custom-painted circular progress with percentage label |
| `SectionHeader` | Section title with optional icon and trailing widget |
| `ShimmerCard` / `ShimmerCardList` / `ShimmerCardGrid` / `ShimmerText` | Shimmer loading placeholders |
| `StatRow` / `StatChip` | Dot-separated stat text and labeled stat chip |
| `StatusBadge` / `PriorityBadge` | Generic status/priority badges with color from hex strings |

---

## 9. API Integration

### SDK Connection

The app connects to Zevaro-Core exclusively through the `zevaro_flutter_sdk` package (local path dependency). No direct HTTP calls are made from the web app.

**Configuration (`main.dart`):**
```dart
const config = SdkConfig(
  baseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080/api/v1'),
  enableLogging: bool.fromEnvironment('ENABLE_LOGGING', defaultValue: true),
);
```

The SDK config is injected by overriding `sdkConfigNotifierProvider` with a custom `_ConfiguredSdkConfigNotifier`.

### SDK Services Used

| SDK Provider | Used For |
|---|---|
| `authStateProvider` | Auth state monitoring (router refresh) |
| `authServiceProvider` | Login, register, forgot/reset password, logout, change password |
| `currentUserProvider` | Current user info (sidebar, header, settings) |
| `currentTenantProvider` | Organization settings |
| `selectedProjectIdProvider` | Global project context |
| `selectedProjectProvider` | Selected project details |
| `projectServiceProvider` | Project CRUD |
| `projectDashboardProvider` | Dashboard data |
| `decisionServiceProvider` | Decision CRUD + comments |
| `decisionQueueProvider` | Decision queue listing |
| `blockingDecisionsProvider` | Blocking decisions count (header alert) |
| `decisionActionsProvider` | Vote, resolve, escalate actions |
| `myPendingResponsesProvider` | User's pending responses |
| `outcomeServiceProvider` | Outcome + Key Result CRUD |
| `myOutcomesProvider` | User's outcomes |
| `hypothesisServiceProvider` | Hypothesis CRUD + transitions |
| `myHypothesesProvider` | User's hypotheses |
| `blockedHypothesesProvider` | Blocked hypotheses |
| `experimentServiceProvider` | Experiment listing + detail |
| `teamServiceProvider` | Team CRUD + member management |
| `myTeamsProvider` | User's teams |
| `stakeholderServiceProvider` | Stakeholder management + reminders |
| `userServiceProvider` | User listing + profile update |

### Data Flow

1. SDK providers fetch data from the backend API
2. Feature providers watch SDK providers, apply client-side filters/grouping
3. Widgets watch feature providers and display data
4. Write operations go through action notifiers which call SDK services, then invalidate cached data

---

## 10. Code Quality Observations

### Architecture Strengths

1. **Clean feature-based organization** - Each feature is self-contained with clear barrel exports
2. **Consistent provider patterns** - All CRUD operations follow the same async notifier pattern with loading/success/error states and provider invalidation
3. **Good separation of concerns** - SDK handles API communication, web app handles UI and local state
4. **Comprehensive color system** - Well-organized color palette covering all use cases
5. **Reusable common widgets** - Good widget library (DraggableKanban, FilterBar, StatusBadge, etc.)
6. **No-transition page strategy** - Appropriate for web SPA feel

### Issues and Concerns

#### Critical

1. **Password validator accepts 1-character passwords** (`auth_form_providers.dart:118`):
   ```dart
   if (value.length < 1) {
     return 'Password must be at least 1 character';
   }
   ```
   The hint text says "At least 8 characters" but the validator allows length >= 1.

2. **Debug print statements in production code** (`auth_guard.dart:17-48`): Six `print()` statements with `[AUTH_GUARD]` prefix are left in the auth guard. These will appear in the browser console in production.

#### Important

3. **Dark mode is forced off** (`app.dart:21`):
   ```dart
   themeMode: ThemeMode.light, // Force light theme
   ```
   The `themeModeSettingProvider` is watched but its value is completely ignored. The ThemeSelector in Settings appears functional but changes have no effect.

4. **Duplicate breakpoint definitions** - `AppConstants` defines mobile(640)/tablet(1024)/desktop(1280) while `AppBreakpoints` defines mobile(600)/tablet(900)/desktop(1200)/wideDesktop(1440). Different parts of the app use different systems, leading to inconsistent responsive behavior.

5. **Conventions file is outdated** - `Zevaro-Web-CONVENTIONS.md` describes a `screens/` + `widgets/` directory structure that does not match the actual `features/` organization. It also references `fl_chart`, `zevaro_sdk` (Git dependency), and screen names that do not exist.

6. **`SidebarItem` and `SidebarSection` widgets are unused** - The sidebar implements its own `_SidebarNavItem` and manual sections. The exported `SidebarItem` and `SidebarSection` widgets in `app_shell_exports.dart` appear to be dead code.

7. **Primary color inconsistency** - `AppColors.primary` is `#3B82F6` (Blue), but `AppTheme` and buttons use `Color(0xFF4F46E5)` (Deep Indigo) as the actual primary accent. These are different colors used in different contexts.

8. **`dashboardStats` provider uses non-existent extensions** (`dashboard_providers.dart:22-23`):
   ```dart
   myOutcomes.where((o) => o.status.isActive).length,
   myHypotheses.where((h) => h.status.isActive).length,
   ```
   These rely on `.isActive` extensions that must come from the SDK. If these are not defined, this will fail at runtime.

#### Minor

9. **Empty directories** - `lib/shared/extensions/` exists but contains no files.

10. **Empty asset directories** - Both `assets/images/` and `assets/icons/` are empty, yet declared in `pubspec.yaml`.

11. **`flutter_svg` and `cached_network_image` dependencies** are declared but not directly used in any source file (may be used transitively by the SDK).

12. **Sort functionality is stubbed** - Multiple sort dropdowns have `onSelected` handlers that are empty or contain `// TODO: Implement sorting` comments (e.g., `decisions_screen.dart:164`, `projects_screen.dart:142-146`).

13. **"My Decisions" filter is stubbed** (`decisions_screen.dart:62-63`):
    ```dart
    onTap: () {
      // TODO: Implement "My Decisions" filter
    },
    ```

14. **Hypothesis experiments provider returns empty list** (`hypotheses_providers.dart:253-255`):
    ```dart
    Future<List<Experiment>> hypothesisExperiments(...) async {
      // TODO: SDK does not yet expose getHypothesisExperiments
      return [];
    }
    ```

15. **Login redirect goes to dashboard** (`login_screen.dart:43`): After login, if there is no redirect query param, the user goes to `Routes.dashboard` (which is `/`). But the initial location is `/projects`. This could cause confusion.

16. **`teamMembersWithStats` only fetches first team** (`teams_providers.dart:141`): `teams.first` is used, which only shows members from the first team, not all teams.

17. **Duplicate sort dropdowns in ProjectsScreen** - There are two sort PopupMenuButtons in Row 2 of the projects screen (one labeled "Sort." and another labeled "Sort: Recent"), both with empty `onSelected` handlers.

18. **`MaterialState` deprecated** (`app_theme.dart:326-337`): The dark theme's `SwitchThemeData` uses `MaterialState` and `MaterialStateProperty`, which are deprecated in favor of `WidgetState` and `WidgetStateProperty` in newer Flutter versions.

19. **`withOpacity` usage** - Multiple files use `Color.withOpacity()` which is deprecated in favor of `Color.withValues()` in newer Flutter/Dart versions.

---

## 11. Known Issues

### Functional Issues

1. **Dark mode does not work** - Theme selector changes are saved to SharedPreferences but the app always renders in light mode due to hardcoded `themeMode: ThemeMode.light`.

2. **Sorting is not implemented** - All sort dropdowns (Projects, Decisions) are non-functional.

3. **"My Decisions" filter is not implemented** - The filter pill exists in the Decisions screen toolbar but has no effect.

4. **Hypothesis experiments are not loaded** - The experiments tab on hypothesis detail screens will always show empty because the SDK method is not yet available.

5. **Team members display is limited** - `teamMembersWithStats` only fetches members from the first team, not aggregated across all teams.

6. **Stakeholders link missing from sidebar** - The sidebar navigation includes Projects, Decision Queue, Outcomes, Hypotheses, Experiments, Team, and Settings, but "Stakeholders" is not shown as a nav item even though the route and screens exist. Stakeholders are only accessible via direct URL navigation.

7. **Dashboard link missing from sidebar** - The Dashboard screen exists at `/` but there is no sidebar nav item for it. Users can only reach it by clicking the logo or navigating directly to `/`.

### UI Issues

1. **Password hint is misleading** - Register screen says "At least 8 characters" but validation accepts any non-empty password.

2. **Console noise** - Auth guard prints debug logs on every route change.

3. **No loading shimmer on most screens** - Despite having `ShimmerCard`/`ShimmerCardList`/`ShimmerCardGrid` widgets available, most screens use `LoadingIndicator` (spinner) instead.

4. **Error messages expose raw exceptions** - The `_formatError` methods only handle a few known exception types; other errors display raw `toString()` output.

### Missing Features

1. **No analytics/reporting screen** - The conventions file mentions an analytics dashboard but it does not exist.
2. **No integrations screen** - Referenced in conventions but not implemented.
3. **No search across all entities** - No global search functionality.
4. **No real-time updates** - No WebSocket or polling for live data updates.
5. **No tests** - The `test/` directory contains only a trivial `widget_test.dart` with two tests (one checks SDK config, one is a no-op assertion).
6. **No offline support** - No service worker or caching strategy for offline use.
7. **No pagination** - `AppConstants.defaultPageSize` is defined (20) but no pagination UI is implemented; lists appear to fetch all records.
8. **No bulk actions** - No ability to select multiple items for batch operations.
9. **Social auth not connected** - `SocialAuthButton` widget exists but is not used in any auth screen.
10. **Delete organization is a stub** - Shows a snackbar saying "contact support" instead of actually deleting.
11. **Billing/Invoices are stubs** - Show "coming soon" snackbars.

---

## Summary Statistics

| Metric | Count |
|---|---|
| Source Files (non-generated) | 153 |
| Lines of Code | ~24,071 |
| Feature Modules | 10 |
| Screens | 20 |
| Custom Widgets | ~80 |
| Riverpod Providers | ~55 (Web) + SDK providers |
| Routes | 18 (4 auth + 14 app) |
| Test Files | 1 (trivial) |
| TODOs in Code | 4 |
