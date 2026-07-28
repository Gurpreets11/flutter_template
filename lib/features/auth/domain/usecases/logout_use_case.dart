import 'package:core_package/core_package.dart';

import '../repositories/auth_repository.dart';

/// Clears the current session.
class LogoutUseCase extends UseCase<void, NoParams> {
  /// Creates a [LogoutUseCase] backed by [_repository].
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.logout();
  }
}
