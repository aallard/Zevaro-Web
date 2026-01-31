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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success =
        await ref.read(forgotPasswordFormStateProvider.notifier).submit(
              email: _emailController.text.trim(),
            );

    if (success && mounted) {
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(forgotPasswordFormStateProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _emailSent
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
            Icons.mark_email_read_outlined,
            size: 48,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Check your email',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'We sent a password reset link to\n${_emailController.text}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        AuthButton(
          label: 'Back to sign in',
          onPressed: () => context.go(Routes.login),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: () => setState(() => _emailSent = false),
          child: const Text("Didn't receive the email? Try again"),
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
          // Back button
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSpacing.lg),

          const AuthHeader(
            title: 'Reset password',
            subtitle: "Enter your email and we'll send you a reset link",
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

          // Email field
          AuthFormField(
            controller: _emailController,
            label: 'Email',
            hint: 'you@company.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: AuthValidators.email,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: _submit,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Submit button
          AuthButton(
            label: 'Send reset link',
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
    if (message.contains('NotFoundException')) {
      return 'No account found with this email';
    }
    return message;
  }
}
