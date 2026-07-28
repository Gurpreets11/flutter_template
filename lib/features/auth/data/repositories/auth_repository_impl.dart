import 'package:core_package/core_package.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

/// A **demo** [AuthRepository] implementation — simulates network
/// latency and accepts any well-formed email with a password of at
/// least 8 characters. No real backend is called.
///
/// Replace this with a real implementation once this app has an actual
/// API: inject an `ApiClient` (from `core_package`) instead of faking
/// the delay, and call the real login/logout/change-password endpoints.
/// The domain layer (`AuthRepository`, the use cases, the presentation
/// layer) doesn't need to change at all when you do this swap — that's
/// the point of the repository pattern.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates an [AuthRepositoryImpl] backed by [_localDataSource].
  AuthRepositoryImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<Result<AuthUser>> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (password.length < 8) {
      return const Result.failure(
        ValidationFailure('Password must be at least 8 characters.'),
      );
    }

    final user = AuthUser(
      id: 'demo-user-1',
      name: email.split('@').first,
      email: email,
    );

    try {
      await _localDataSource.saveSession(token: 'demo-token', user: user);
      return Result.success(user);
    } catch (error) {
      return Result.failure(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _localDataSource.clearSession();
      return const Result.success(null);
    } catch (error) {
      return Result.failure(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (newPassword.length < 8) {
      return const Result.failure(
        ValidationFailure('New password must be at least 8 characters.'),
      );
    }

    // Demo only — a real implementation calls the change-password
    // endpoint via ApiClient here.
    return const Result.success(null);
  }

  @override
  Future<AuthUser?> currentUser() => _localDataSource.readUser();
}
