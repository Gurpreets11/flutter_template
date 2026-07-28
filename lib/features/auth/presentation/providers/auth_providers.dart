import 'package:core_package/core_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/change_password_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

/// The secure storage service backing session persistence.
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageServiceImpl();
});

/// The local data source persisting the session.
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(storage: ref.watch(secureStorageServiceProvider));
});

/// The auth repository. Swap [AuthRepositoryImpl] for a real,
/// API-backed implementation once this app has an actual backend —
/// nothing above this provider needs to change when you do.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authLocalDataSourceProvider));
});

final _loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final _logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final _changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.watch(authRepositoryProvider));
});

/// The single source of truth for auth state across the app — used by
/// the router's redirect logic and by the login/change-password
/// screens.
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    loginUseCase: ref.watch(_loginUseCaseProvider),
    logoutUseCase: ref.watch(_logoutUseCaseProvider),
    changePasswordUseCase: ref.watch(_changePasswordUseCaseProvider),
    readCurrentUser: () => ref.read(authRepositoryProvider).currentUser(),
  );
});
