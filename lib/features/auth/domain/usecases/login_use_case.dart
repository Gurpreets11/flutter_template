import 'package:core_package/core_package.dart';

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for [LoginUseCase].
class LoginParams {
  /// Creates [LoginParams].
  const LoginParams({required this.email, required this.password});

  /// The email entered on the login screen.
  final String email;

  /// The password entered on the login screen.
  final String password;
}

/// Logs a user in and persists their session.
class LoginUseCase extends UseCase<AuthUser, LoginParams> {
  /// Creates a [LoginUseCase] backed by [_repository].
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AuthUser>> call(LoginParams params) {
    return _repository.login(params.email, params.password);
  }
}
