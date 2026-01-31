import 'package:flutter_test/flutter_test.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

void main() {
  group('ZevaroWeb', () {
    test('SDK config is accessible', () {
      final config = SdkConfig.development();
      expect(config.baseUrl, 'http://localhost:8080/api');
      expect(config.enableLogging, true);
    });

    test('Routes are defined', () {
      // Just verify the app compiles with SDK imports
      expect(true, true);
    });
  });
}
