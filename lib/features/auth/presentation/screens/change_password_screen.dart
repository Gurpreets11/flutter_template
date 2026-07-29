import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';

/// The change-password screen — current/new/confirm password fields
/// wired to [authControllerProvider.changePassword].
class ChangePasswordScreen extends ConsumerStatefulWidget {
  /// Creates a [ChangePasswordScreen].
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success =
        await ref.read(authControllerProvider.notifier).changePassword(
              currentPassword: _currentPasswordController.text,
              newPassword: _newPasswordController.text,
            );

    if (success && mounted) {
      AppSnackbar.showSuccess(context, 'Password updated.');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        AppSnackbar.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: const AppCommonBar(title: 'Change password'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(config.spacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Current password',
                  controller: _currentPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: Validators.required(),
                ),
                SizedBox(height: config.spacing.sm),
                AppTextField(
                  label: 'New password',
                  controller: _newPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_reset_outlined,
                  validator: Validators.compose([
                    Validators.required(),
                    Validators.password(),
                  ]),
                ),
                SizedBox(height: config.spacing.sm),
                AppTextField(
                  label: 'Confirm new password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_reset_outlined,
                  validator: Validators.compose([
                    Validators.required(),
                    Validators.matches(
                      () => _newPasswordController.text,
                      message: 'Passwords do not match.',
                    ),
                  ]),
                ),
                SizedBox(height: config.spacing.lg),
                AppButton(
                  label: 'Update password',
                  isLoading: authState.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
