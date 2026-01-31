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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _tenantNameController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  bool _hasInviteCode = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tenantNameController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(registerFormStateProvider.notifier).submit(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          tenantName: _hasInviteCode ? null : _tenantNameController.text.trim(),
          inviteCode: _hasInviteCode ? _inviteCodeController.text.trim() : null,
        );

    if (success && mounted) {
      context.go(Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(registerFormStateProvider);
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
                    title: 'Create your account',
                    subtitle: 'Start making faster decisions today',
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

                  // Name fields (row)
                  Row(
                    children: [
                      Expanded(
                        child: AuthFormField(
                          controller: _firstNameController,
                          label: 'First name',
                          hint: 'John',
                          validator: (v) =>
                              AuthValidators.required(v, 'First name'),
                          autofocus: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AuthFormField(
                          controller: _lastNameController,
                          label: 'Last name',
                          hint: 'Doe',
                          validator: (v) =>
                              AuthValidators.required(v, 'Last name'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Email field
                  AuthFormField(
                    controller: _emailController,
                    label: 'Work email',
                    hint: 'you@company.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: AuthValidators.email,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Password field
                  AuthFormField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'At least 8 characters',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    validator: AuthValidators.password,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Confirm password field
                  AuthFormField(
                    controller: _confirmPasswordController,
                    label: 'Confirm password',
                    hint: 'Re-enter your password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    validator: (v) => AuthValidators.confirmPassword(
                      v,
                      _passwordController.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Toggle: New tenant vs invite code
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _hasInviteCode = false),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: !_hasInviteCode
                                  ? AppColors.primary.withOpacity(0.1)
                                  : AppColors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd),
                              border: Border.all(
                                color: !_hasInviteCode
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.add_business,
                                  color: !_hasInviteCode
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'New organization',
                                  style: TextStyle(
                                    color: !_hasInviteCode
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _hasInviteCode = true),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: _hasInviteCode
                                  ? AppColors.primary.withOpacity(0.1)
                                  : AppColors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd),
                              border: Border.all(
                                color: _hasInviteCode
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.mail_outline,
                                  color: _hasInviteCode
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'I have an invite',
                                  style: TextStyle(
                                    color: _hasInviteCode
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Tenant name or invite code
                  if (_hasInviteCode)
                    AuthFormField(
                      controller: _inviteCodeController,
                      label: 'Invite code',
                      hint: 'Enter your invite code',
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                      validator: (v) =>
                          AuthValidators.required(v, 'Invite code'),
                    )
                  else
                    AuthFormField(
                      controller: _tenantNameController,
                      label: 'Organization name',
                      hint: 'Acme Inc.',
                      prefixIcon: const Icon(Icons.business_outlined),
                      validator: (v) =>
                          AuthValidators.required(v, 'Organization name'),
                    ),
                  const SizedBox(height: AppSpacing.xl),

                  // Submit button
                  AuthButton(
                    label: 'Create account',
                    onPressed: _submit,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => context.push(Routes.login),
                        child: const Text('Sign in'),
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
    if (message.contains('ValidationException')) {
      return 'Please check your information and try again';
    }
    return message;
  }
}
