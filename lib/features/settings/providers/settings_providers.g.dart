// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeModeSettingHash() => r'b158c8f370a5bd28d481a79c6a8b969ccb70bb25';

/// Theme mode preference
///
/// Copied from [ThemeModeSetting].
@ProviderFor(ThemeModeSetting)
final themeModeSettingProvider =
    AutoDisposeNotifierProvider<ThemeModeSetting, ThemeMode>.internal(
  ThemeModeSetting.new,
  name: r'themeModeSettingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeSettingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeModeSetting = AutoDisposeNotifier<ThemeMode>;
String _$notificationSettingsHash() =>
    r'57e622e4b97bc67ab89fb0ca53b8a9a18e62e41d';

/// Notification preferences
///
/// Copied from [NotificationSettings].
@ProviderFor(NotificationSettings)
final notificationSettingsProvider = AutoDisposeNotifierProvider<
    NotificationSettings, NotificationPrefs>.internal(
  NotificationSettings.new,
  name: r'notificationSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationSettings = AutoDisposeNotifier<NotificationPrefs>;
String _$updateProfileHash() => r'3ec906a25912956eb4551b980941412c7601e5f0';

/// Update user profile
///
/// Copied from [UpdateProfile].
@ProviderFor(UpdateProfile)
final updateProfileProvider =
    AutoDisposeAsyncNotifierProvider<UpdateProfile, void>.internal(
  UpdateProfile.new,
  name: r'updateProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateProfile = AutoDisposeAsyncNotifier<void>;
String _$changePasswordHash() => r'84795b48ef68015d126a2afab4f264e285765a6a';

/// Change password
///
/// Copied from [ChangePassword].
@ProviderFor(ChangePassword)
final changePasswordProvider =
    AutoDisposeAsyncNotifierProvider<ChangePassword, void>.internal(
  ChangePassword.new,
  name: r'changePasswordProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$changePasswordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChangePassword = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
