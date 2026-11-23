import 'dart:convert';

import 'package:core_package/core_package.dart';

import '../models/user_model.dart';

/// Authentication operations for this feature.
///
/// This starter implementation is intentionally a demo: login accepts
/// any valid email and a password of at least 8 characters. Replace the
/// simulated operations with your backend API calls when integrating
/// a real server.
class AuthService {
  AuthService({required SecureStorageService storage}) : _storage = storage;

  final SecureStorageService _storage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  Future<UserModel?> currentUser() async {
    try {
      final raw = await _storage.read(key: _userKey);
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
      );
    } catch (error) {
      AppLogger.error('Failed to read cached user', error: error);
      return null;
    }
  }

  Future<Result<UserModel>> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (password.length < 8) {
      return const Result.failure(
        ValidationFailure('Password must be at least 8 characters.'),
      );
    }

    final user = UserModel(
      id: 'demo-user-1',
      name: email.split('@').first,
      email: email,
    );

    try {
      await _storage.write(key: _tokenKey, value: 'demo-token');
      await _storage.write(
        key: _userKey,
        value: jsonEncode({
          'id': user.id,
          'name': user.name,
          'email': user.email,
        }),
      );
      return Result.success(user);
    } catch (error) {
      return Result.failure(ExceptionMapper.toFailure(error));
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
      return const Result.success(null);
    } catch (error) {
      return Result.failure(ExceptionMapper.toFailure(error));
    }
  }

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
    // Demo only. Call the change-password endpoint in a real application.
    return const Result.success(null);
  }
}
