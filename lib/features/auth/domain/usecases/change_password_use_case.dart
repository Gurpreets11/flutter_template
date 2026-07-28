import 'package:core_package/core_package.dart';

import '../repositories/auth_repository.dart';

/// Parameters for [ChangePasswordUseCase].
class ChangePasswordParams {
  /// Creates [ChangePasswordParams].
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  /// The user's current password, for verification.
  final String currentPassword;

  /// The new password to set.
  final String newPassword;
}

/// Changes the current user's password.
class ChangePasswordUseCase extends UseCase<void, ChangePasswordParams> {
  /// Creates a [ChangePasswordUseCase] backed by [_repository].
  ChangePasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(ChangePasswordParams params) {
    return _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}
