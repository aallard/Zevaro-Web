import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      overrides: [
        // Configure SDK for environment
        // In production, read from environment variables
        sdkConfigNotifierProvider.overrideWith(
          () => SdkConfigNotifier()
            ..setConfig(
              const SdkConfig(
                baseUrl: String.fromEnvironment(
                  'API_BASE_URL',
                  defaultValue: 'http://localhost:8080/api',
                ),
                enableLogging: bool.fromEnvironment(
                  'ENABLE_LOGGING',
                  defaultValue: true,
                ),
              ),
            ),
        ),
      ],
      child: const ZevaroApp(),
    ),
  );
}
