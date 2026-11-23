import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController({required AuthService authService})
      : _authService = authService,
        super(const AuthState()) {
    _checkSession();
  }

  final AuthService _authService;

  Future<void> _checkSession() async {
    try {
      final user = await _authService.currentUser();
      state = state.copyWith(
        status: user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
        user: user,
      );
    } catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _authService.login(email, password);
    result.when(
      onSuccess: (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      ),
      onFailure: (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _authService.logout();
    result.when(
      onSuccess: (_) => state = const AuthState(
        status: AuthStatus.unauthenticated,
      ),
      onFailure: (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
    );
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
    );
  }
}
