import 'dart:convert';

import 'package:core_package/core_package.dart';

import '../../domain/entities/auth_user.dart';

/// Persists the session token and cached user in secure storage.
///
/// Depends on [SecureStorageService] (from `core_package`) rather than
/// `flutter_secure_storage` directly — this is what makes
/// [AuthLocalDataSource] unit-testable with a fake storage service
/// instead of needing a mocked platform channel.
class AuthLocalDataSource {
  /// Creates an [AuthLocalDataSource] backed by [storage].
  AuthLocalDataSource({required SecureStorageService storage})
      : _storage = storage;

  final SecureStorageService _storage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  /// Persists the session [token] and [user].
  Future<void> saveSession({
    required String token,
    required AuthUser user,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(
      key: _userKey,
      value: jsonEncode({
        'id': user.id,
        'name': user.name,
        'email': user.email,
      }),
    );
  }

  /// Returns the persisted token, or `null` if none exists.
  Future<String?> readToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (error) {
      AppLogger.error('Failed to read token', error: error);
      return null;
    }
  }

  /// Returns the persisted user, or `null` if none exists.
  Future<AuthUser?> readUser() async {
    try {
      final raw = await _storage.read(key: _userKey);
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AuthUser(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
      );
    } catch (error) {
      AppLogger.error('Failed to read cached user', error: error);
      return null;
    }
  }

  /// Clears the persisted session.
  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
