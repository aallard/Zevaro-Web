# Zevaro Web

Official Flutter Web client for the Zevaro COE (Continuous Outcome Engineering) platform.

## Prerequisites

- Flutter SDK 3.2.0 or higher
- Dart SDK 3.2.0 or higher

## Setup

```bash
# Install dependencies
flutter pub get

# Generate code (router, providers)
dart run build_runner build --delete-conflicting-outputs
```

## Development

```bash
# Run in Chrome
flutter run -d chrome

# Run with custom API URL
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080/api
```

## Build

```bash
# Production build
flutter build web --release \
  --dart-define=API_BASE_URL=https://api.zevaro.io \
  --dart-define=ENABLE_LOGGING=false

# Output in build/web/
```

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── app.dart                  # App widget with ProviderScope
├── core/
│   ├── router/               # GoRouter configuration
│   │   ├── app_router.dart
│   │   ├── routes.dart
│   │   └── guards/
│   ├── theme/                # Design system
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_spacing.dart
│   └── constants/
├── features/                 # Feature modules
│   ├── auth/
│   ├── dashboard/
│   ├── decisions/            # CORE - Decision Queue
│   ├── outcomes/
│   ├── hypotheses/
│   ├── teams/
│   └── settings/
└── shared/
    ├── widgets/
    └── extensions/
```

## Dependencies

- **zevaro_flutter_sdk** - Shared SDK with models, services, and providers
- **flutter_riverpod** - State management
- **go_router** - Declarative routing
- **flutter_svg** - SVG rendering
- **cached_network_image** - Image caching

## Version

1.0.0
