import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/features/auth/models/user_model.dart';
import 'package:flutter_template/features/auth/services/auth_service.dart';

class _FakeSecureStorageService implements SecureStorageService {
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

void main() {
  late _FakeSecureStorageService storage;
  late AuthService service;

  setUp(() {
    storage = _FakeSecureStorageService();
    service = AuthService(storage: storage);
  });

  group('AuthService', () {
    test('returns null when no cached user exists', () async {
      expect(await service.currentUser(), isNull);
    });

    test('login persists token and user for valid password', () async {
      final result = await service.login('jane@example.com', 'password123');

      expect(result.isSuccess, isTrue);
      expect(storage.values['auth_token'], 'demo-token');
      expect(await service.currentUser(), isA<UserModel>());
      expect((await service.currentUser())?.email, 'jane@example.com');
    });

    test('login rejects password shorter than eight characters', () async {
      final result = await service.login('jane@example.com', 'short');

      expect(result.isFailure, isTrue);
      expect(storage.values, isEmpty);
    });

    test('logout removes persisted session', () async {
      await service.login('jane@example.com', 'password123');
      final result = await service.logout();

      expect(result.isSuccess, isTrue);
      expect(storage.values, isEmpty);
      expect(await service.currentUser(), isNull);
    });

    test('change password rejects short new password', () async {
      final result = await service.changePassword(
        currentPassword: 'oldpassword',
        newPassword: 'short',
      );

      expect(result.isFailure, isTrue);
    });

    test('change password accepts valid new password in demo mode', () async {
      final result = await service.changePassword(
        currentPassword: 'oldpassword',
        newPassword: 'newpassword',
      );

      expect(result.isSuccess, isTrue);
    });
  });
}
