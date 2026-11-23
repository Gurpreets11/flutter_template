import 'package:core_package/core_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageServiceImpl();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(storage: ref.watch(secureStorageServiceProvider));
});

/// Shared authentication state for the whole application.
final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(authService: ref.watch(authServiceProvider));
});
