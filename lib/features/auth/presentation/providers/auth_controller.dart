import 'package:core_package/core_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/change_password_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import 'auth_state.dart';

/// A single controller owning all auth state — session check, login,
/// logout, and change-password — so the app has one source of truth
/// for "is the user signed in," rather than several notifiers that can
/// drift out of sync with each other.
class AuthController extends StateNotifier<AuthState> {
  /// Creates an [AuthController] and immediately checks for a
  /// persisted session.
  AuthController({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required Future<AuthUser?> Function() readCurrentUser,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _changePasswordUseCase = changePasswordUseCase,
        _readCurrentUser = readCurrentUser,
        super(const AuthState()) {
    _checkSession();
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final Future<AuthUser?> Function() _readCurrentUser;

  Future<void> _checkSession() async {
    final user = await _readCurrentUser();
    state = state.copyWith(
      status:
          user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      user: user,
    );
  }

  /// Attempts to log in with [email]/[password].
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.when(
      onSuccess: (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  /// Logs the current user out.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _logoutUseCase(NoParams.instance);

    result.when(
      onSuccess: (_) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  /// Changes the current user's password.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }
}
