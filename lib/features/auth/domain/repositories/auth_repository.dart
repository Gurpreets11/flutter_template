import 'package:core_package/core_package.dart';

import '../entities/auth_user.dart';

/// The domain-layer contract for authentication. Implemented in
/// `data/repositories/auth_repository_impl.dart`.
///
/// The starter's implementation is a **demo/mock** — it doesn't call a
/// real backend. Replace `AuthRepositoryImpl` with a real
/// implementation (using `ApiClient` from `core_package`) once this app
/// has an actual API to talk to.
abstract class AuthRepository implements Repository {
  /// Attempts to log in with [email]/[password]. On success, persists
  /// the session so [currentUser] reflects it afterward.
  Future<Result<AuthUser>> login(String email, String password);

  /// Clears the current session.
  Future<Result<void>> logout();

  /// Changes the current user's password.
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Returns the currently persisted user, or `null` if no session
  /// exists (used by the splash screen to decide where to route).
  Future<AuthUser?> currentUser();
}
