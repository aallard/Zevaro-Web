import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header.dart';
import '../providers/auth_form_providers.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? token;

  const ResetPasswordScreen({super.key, this.token});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _resetComplete = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final token = widget.token ??
        GoRouterState.of(context).uri.queryParameters['token'];

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid reset link. Please request a new one.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success =
        await ref.read(resetPasswordFormStateProvider.notifier).submit(
              token: token,
              newPassword: _passwordController.text,
            );

    if (success && mounted) {
      setState(() => _resetComplete = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(resetPasswordFormStateProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _resetComplete
                ? _buildSuccessView()
                : _buildFormView(isLoading, formState),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            size: 48,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Password reset complete',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Your password has been successfully reset.\nYou can now sign in with your new password.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        AuthButton(
          label: 'Sign in',
          onPressed: () => context.go(Routes.login),
        ),
      ],
    );
  }

  Widget _buildFormView(bool isLoading, AsyncValue<void> formState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthHeader(
            title: 'Set new password',
            subtitle: 'Enter your new password below',
          ),
          const SizedBox(height: AppSpacing.xl),

          // Error message
          if (formState.hasError) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border:
                    Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _formatError(formState.error),
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Password field
          AuthFormField(
            controller: _passwordController,
            label: 'New password',
            hint: 'At least 8 characters',
            obscureText: true,
            prefixIcon: const Icon(Icons.lock_outlined),
            validator: AuthValidators.password,
            autofocus: true,
          ),
          const SizedBox(height: AppSpacing.md),

          // Confirm password field
          AuthFormField(
            controller: _confirmPasswordController,
            label: 'Confirm new password',
            hint: 'Re-enter your password',
            obscureText: true,
            prefixIcon: const Icon(Icons.lock_outlined),
            validator: (v) => AuthValidators.confirmPassword(
              v,
              _passwordController.text,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: _submit,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Submit button
          AuthButton(
            label: 'Reset password',
            onPressed: _submit,
            isLoading: isLoading,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Back to login
          Center(
            child: TextButton(
              onPressed: () => context.go(Routes.login),
              child: const Text('Back to sign in'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatError(Object? error) {
    if (error == null) return 'An error occurred';
    final message = error.toString();
    if (message.contains('ValidationException')) {
      return 'Invalid or expired reset link. Please request a new one.';
    }
    return message;
  }
}
