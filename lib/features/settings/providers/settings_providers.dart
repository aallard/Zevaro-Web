import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'settings_providers.g.dart';

/// Theme mode preference
@riverpod
class ThemeModeSetting extends _$ThemeModeSetting {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    _loadFromPrefs();
    return ThemeMode.light;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value != null) {
      state = ThemeMode.values.firstWhere(
        (m) => m.name == value,
        orElse: () => ThemeMode.light,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

/// Notification preferences
@riverpod
class NotificationSettings extends _$NotificationSettings {
  @override
  NotificationPrefs build() {
    _loadFromPrefs();
    return const NotificationPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationPrefs(
      emailOnDecision: prefs.getBool('notify_email_decision') ?? true,
      emailOnMention: prefs.getBool('notify_email_mention') ?? true,
      emailDigest: prefs.getBool('notify_email_digest') ?? true,
      pushOnUrgent: prefs.getBool('notify_push_urgent') ?? true,
    );
  }

  Future<void> setEmailOnDecision(bool value) async {
    state = state.copyWith(emailOnDecision: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify_email_decision', value);
  }

  Future<void> setEmailOnMention(bool value) async {
    state = state.copyWith(emailOnMention: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify_email_mention', value);
  }

  Future<void> setEmailDigest(bool value) async {
    state = state.copyWith(emailDigest: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify_email_digest', value);
  }

  Future<void> setPushOnUrgent(bool value) async {
    state = state.copyWith(pushOnUrgent: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify_push_urgent', value);
  }
}

class NotificationPrefs {
  final bool emailOnDecision;
  final bool emailOnMention;
  final bool emailDigest;
  final bool pushOnUrgent;

  const NotificationPrefs({
    this.emailOnDecision = true,
    this.emailOnMention = true,
    this.emailDigest = true,
    this.pushOnUrgent = true,
  });

  NotificationPrefs copyWith({
    bool? emailOnDecision,
    bool? emailOnMention,
    bool? emailDigest,
    bool? pushOnUrgent,
  }) {
    return NotificationPrefs(
      emailOnDecision: emailOnDecision ?? this.emailOnDecision,
      emailOnMention: emailOnMention ?? this.emailOnMention,
      emailDigest: emailDigest ?? this.emailDigest,
      pushOnUrgent: pushOnUrgent ?? this.pushOnUrgent,
    );
  }
}

/// Update user profile
@riverpod
class UpdateProfile extends _$UpdateProfile {
  @override
  FutureOr<void> build() {}

  Future<bool> updateUser(UpdateUserRequest request) async {
    state = const AsyncValue.loading();

    try {
      final userService = ref.read(userServiceProvider);
      final currentUser = await ref.read(currentUserProvider.future);
      await userService.updateUser(currentUser.id, request);

      ref.invalidate(currentUserProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Change password
@riverpod
class ChangePassword extends _$ChangePassword {
  @override
  FutureOr<void> build() {}

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    state = const AsyncValue.loading();
    // TODO: Core does not yet expose a change-password endpoint
    state = AsyncValue.error(
      UnimplementedError('Password change is not yet available'),
      StackTrace.current,
    );
    return false;
  }
}
