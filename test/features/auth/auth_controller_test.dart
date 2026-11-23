import 'package:core_package/core_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/features/auth/models/user_model.dart';
import 'package:flutter_template/features/auth/providers/auth_controller.dart';
import 'package:flutter_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_template/features/auth/providers/auth_state.dart';
import 'package:flutter_template/features/auth/services/auth_service.dart';

class _FakeStorage implements SecureStorageService {
  final Map<String, String> values = {};

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> delete({required String key}) async => values.remove(key);

  @override
  Future<void> deleteAll() async => values.clear();
}

class _FakeAuthService extends AuthService {
  _FakeAuthService() : super(storage: _FakeStorage());

  UserModel? sessionUser;
  Result<UserModel> loginResult = const Result.failure(
    ValidationFailure('Not configured'),
  );
  Result<void> logoutResult = const Result.success(null);
  Result<void> changePasswordResult = const Result.success(null);

  @override
  Future<UserModel?> currentUser() async => sessionUser;

  @override
  Future<Result<UserModel>> login(String email, String password) async {
    if (loginResult.isSuccess) {
      // The test sets sessionUser explicitly to the expected signed-in user.
    }
    return loginResult;
  }

  @override
  Future<Result<void>> logout() async => logoutResult;

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async =>
      changePasswordResult;
}

void main() {
  late _FakeAuthService service;
  late ProviderContainer container;
  late AuthController controller;

  const user = UserModel(
    id: '1',
    name: 'Jane',
    email: 'jane@example.com',
  );

  setUp(() {
    service = _FakeAuthService();
    container = ProviderContainer(
      overrides: [authServiceProvider.overrideWithValue(service)],
    );
    controller = container.read(authProvider.notifier);
  });

  tearDown(() => container.dispose());

  group('AuthController session check', () {
    test('sets unauthenticated when no session exists', () async {
      await Future<void>.delayed(Duration.zero);
      expect(controller.state.status, AuthStatus.unauthenticated);
      expect(controller.state.user, isNull);
    });

    test('restores authenticated user when a session exists', () async {
      service.sessionUser = user;
      // Recreate the container so the controller checks the configured session.
      container.dispose();
      container = ProviderContainer(
        overrides: [authServiceProvider.overrideWithValue(service)],
      );
      controller = container.read(authProvider.notifier);

      await Future<void>.delayed(Duration.zero);

      expect(controller.state.status, AuthStatus.authenticated);
      expect(controller.state.user, user);
    });
  });

  group('AuthController.login', () {
    test('sets authenticated status and user on success', () async {
      service.loginResult = const Result.success(user);

      await controller.login('jane@example.com', 'password123');

      expect(controller.state.status, AuthStatus.authenticated);
      expect(controller.state.user, user);
      expect(controller.state.isLoading, isFalse);
    });

    test('sets an error message on failure', () async {
      service.loginResult = const Result.failure(
        ValidationFailure('Password must be at least 8 characters.'),
      );

      await controller.login('jane@example.com', 'bad');

      expect(controller.state.status, isNot(AuthStatus.authenticated));
      expect(controller.state.errorMessage, isNotNull);
      expect(controller.state.isLoading, isFalse);
    });
  });

  group('AuthController.logout', () {
    test('resets to unauthenticated on success', () async {
      await controller.logout();

      expect(controller.state.status, AuthStatus.unauthenticated);
      expect(controller.state.user, isNull);
    });

    test('keeps state and exposes error on failure', () async {
      service.logoutResult = const Result.failure(
        ValidationFailure('Logout failed'),
      );

      await controller.logout();

      expect(controller.state.isLoading, isFalse);
      expect(controller.state.errorMessage, 'Logout failed');
    });
  });

  group('AuthController.changePassword', () {
    test('returns true on success', () async {
      final result = await controller.changePassword(
        currentPassword: 'old12345',
        newPassword: 'new12345',
      );

      expect(result, isTrue);
      expect(controller.state.isLoading, isFalse);
    });

    test('returns false and exposes error on failure', () async {
      service.changePasswordResult = const Result.failure(
        ValidationFailure('Password update failed'),
      );

      final result = await controller.changePassword(
        currentPassword: 'old12345',
        newPassword: 'bad',
      );

      expect(result, isFalse);
      expect(controller.state.errorMessage, 'Password update failed');
    });
  });
}
