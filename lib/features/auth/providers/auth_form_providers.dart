import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'auth_form_providers.g.dart';

/// Login form state
@riverpod
class LoginFormState extends _$LoginFormState {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> submit({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // Use AuthState.login() which properly sets auth state for the router guard
      await ref.read(authStateProvider.notifier).login(LoginRequest(
        email: email,
        password: password,
      ));
    });

    return !state.hasError;
  }
}

/// Register form state
@riverpod
class RegisterFormState extends _$RegisterFormState {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> submit({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? tenantName,
    String? inviteCode,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.register(RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        tenantName: tenantName,
        inviteCode: inviteCode,
      ));
    });

    return !state.hasError;
  }
}

/// Forgot password form state
@riverpod
class ForgotPasswordFormState extends _$ForgotPasswordFormState {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> submit({required String email}) async {
    state = const AsyncValue.loading();
    // TODO: Core does not yet expose a forgot-password endpoint
    state = AsyncValue.error(
      UnimplementedError('Password reset is not yet available'),
      StackTrace.current,
    );
    return false;
  }
}

/// Reset password form state
@riverpod
class ResetPasswordFormState extends _$ResetPasswordFormState {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> submit({
    required String token,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();
    // TODO: Core does not yet expose a reset-password endpoint
    state = AsyncValue.error(
      UnimplementedError('Password reset is not yet available'),
      StackTrace.current,
    );
    return false;
  }
}

/// Form validators
class AuthValidators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 1) {
      return 'Password must be at least 1 character';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
