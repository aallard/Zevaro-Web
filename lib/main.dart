import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure SDK for environment
  const config = SdkConfig(
    baseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080/api',
    ),
    enableLogging: bool.fromEnvironment(
      'ENABLE_LOGGING',
      defaultValue: true,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        // Override the SDK config with our environment config
        sdkConfigNotifierProvider.overrideWith(
          () => _ConfiguredSdkConfigNotifier(config),
        ),
      ],
      child: const ZevaroApp(),
    ),
  );
}

/// Custom notifier that returns the configured SDK config in build()
class _ConfiguredSdkConfigNotifier extends SdkConfigNotifier {
  final SdkConfig _config;

  _ConfiguredSdkConfigNotifier(this._config);

  @override
  SdkConfig build() => _config;
}
