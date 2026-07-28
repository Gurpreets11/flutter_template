import 'dart:convert';

import 'package:core_package/core_package.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/auth_user.dart';

/// Persists the session token and cached user in secure storage.
///
/// **Note:** `core_package` doesn't have its own secure storage wrapper
/// yet (it's a planned addition — see the project's architecture
/// roadmap). Until then, apps built from this starter depend on
/// `flutter_secure_storage` directly here. When `core_package` adds its
/// storage module, migrate this class to use it instead, so token
/// handling is centralized like everything else.
class AuthLocalDataSource {
  /// Creates an [AuthLocalDataSource]. Uses the default
  /// [FlutterSecureStorage] unless [storage] is provided (useful for
  /// tests).
  AuthLocalDataSource({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  /// Persists the session [token] and [user].
  Future<void> saveSession({
    required String token,
    required AuthUser user,
  }) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(
        key: _userKey,
        value: jsonEncode({
          'id': user.id,
          'name': user.name,
          'email': user.email,
        }),
      );
    } catch (error) {
      throw CacheException('Failed to save session: $error');
    }
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
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
    } catch (error) {
      throw CacheException('Failed to clear session: $error');
    }
  }
}
