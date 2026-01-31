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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(loginFormStateProvider.notifier).submit(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      // Get redirect URL from query params or go to dashboard
      final redirect =
          GoRouterState.of(context).uri.queryParameters['redirect'];
      context.go(redirect ?? Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormStateProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    title: 'Welcome back',
                    subtitle: 'Sign in to continue to Zevaro',
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Error message
                  if (formState.hasError) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(
                            color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppColors.error),
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

                  // Email field
                  AuthFormField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'you@company.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: AuthValidators.email,
                    autofocus: true,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Password field
                  AuthFormField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    validator: AuthValidators.password,
                    textInputAction: TextInputAction.done,
                    onSubmitted: _submit,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(Routes.forgotPassword),
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Submit button
                  AuthButton(
                    label: 'Sign in',
                    onPressed: _submit,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => context.push(Routes.register),
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatError(Object? error) {
    if (error == null) return 'An error occurred';
    final message = error.toString();
    // Clean up common exception prefixes
    if (message.contains('UnauthorizedException')) {
      return 'Invalid email or password';
    }
    if (message.contains('ValidationException')) {
      return 'Please check your credentials';
    }
    return message;
  }
}
