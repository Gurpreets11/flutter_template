import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_user.dart';

/// The app's overall authentication status.
enum AuthStatus {
  /// Not yet determined — the splash screen is still checking for a
  /// persisted session.
  unknown,

  /// A valid session exists.
  authenticated,

  /// No valid session exists.
  unauthenticated,
}

/// The full auth state exposed to the UI: [status] for routing
/// decisions, plus [isLoading]/[errorMessage] for the login and
/// change-password screens' in-progress/error UI.
@immutable
class AuthState {
  /// Creates an [AuthState].
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  /// The current auth status, used by the router's redirect logic.
  final AuthStatus status;

  /// The signed-in user, if [status] is [AuthStatus.authenticated].
  final AuthUser? user;

  /// Whether an auth operation (login/logout/change password) is in
  /// flight — drives `AppButton.isLoading` on the relevant screens.
  final bool isLoading;

  /// The most recent operation's error message, if any.
  final String? errorMessage;

  /// Returns a copy with the given fields replaced. Pass
  /// `clearError: true` to explicitly null out [errorMessage] (since
  /// the default `copyWith` pattern can't distinguish "leave unchanged"
  /// from "set to null").
  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
